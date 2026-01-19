import 'package:flutter/material.dart';
import 'package:movie_pitch_generator/data/wheel_data.dart';
import 'package:movie_pitch_generator/models/pitch_result.dart';
import 'package:movie_pitch_generator/services/pitch_api_service.dart';
import 'package:movie_pitch_generator/widgets/action_buttons.dart';
import 'package:movie_pitch_generator/widgets/generating_pitch_dialog.dart';
import 'package:movie_pitch_generator/widgets/spinning_wheel.dart';
import 'package:movie_pitch_generator/widgets/wheel_category_section.dart';
import 'package:movie_pitch_generator/screens/pitch_result_screen.dart';

/// Main screen where users configure and spin wheels.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PitchApiService _apiService = PitchApiService();

  // Track wheel counts per category
  late Map<String, int> _wheelCounts;

  // Track GlobalKeys for each wheel in each category
  late Map<String, List<GlobalKey<SpinningWheelState>>> _wheelKeys;

  bool _isSpinning = false;
  bool _isGeneratingPitch = false;

  // Accent colors for each category
  static const List<Color> categoryColors = [
    Color(0xFFFF6B6B), // Characters - coral red
    Color(0xFF4ECDC4), // Creatives - teal
    Color(0xFFFFE66D), // Locations - golden yellow
    Color(0xFF95E1D3), // Genres - mint green
  ];

  @override
  void initState() {
    super.initState();
    _initializeWheels();
  }

  void _initializeWheels() {
    _wheelCounts = {};
    _wheelKeys = {};

    for (final category in wheelCategories) {
      _wheelCounts[category.id] = category.defaultWheelCount;
      _wheelKeys[category.id] = List.generate(
        category.maxWheels,
        (_) => GlobalKey<SpinningWheelState>(),
      );
    }
  }

  void _addWheel(String categoryId) {
    final category = wheelCategories.firstWhere((c) => c.id == categoryId);
    if (_wheelCounts[categoryId]! < category.maxWheels) {
      setState(() {
        _wheelCounts[categoryId] = _wheelCounts[categoryId]! + 1;
      });
    }
  }

  void _removeWheel(String categoryId) {
    final category = wheelCategories.firstWhere((c) => c.id == categoryId);
    if (_wheelCounts[categoryId]! > category.minWheels) {
      setState(() {
        _wheelCounts[categoryId] = _wheelCounts[categoryId]! - 1;
      });
    }
  }

  /// Spins all non-locked wheels. Wheels auto-lock after spinning.
  Future<void> _spinWheels() async {
    if (_isSpinning) return;

    // Check for empty textboxes in edit mode
    for (final category in wheelCategories) {
      final wheelCount = _wheelCounts[category.id]!;
      final keys = _wheelKeys[category.id]!;

      for (int i = 0; i < wheelCount; i++) {
        final key = keys[i];
        if (key.currentState != null && key.currentState!.hasEmptyEditText) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enter text for all ${category.displayName} fields or switch back to wheel mode.',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
      }
    }

    setState(() {
      _isSpinning = true;
    });

    // Collect all spin futures for non-locked wheels
    final List<Future<String>> spinFutures = [];

    for (final category in wheelCategories) {
      final wheelCount = _wheelCounts[category.id]!;
      final keys = _wheelKeys[category.id]!;

      for (int i = 0; i < wheelCount; i++) {
        final key = keys[i];
        if (key.currentState != null && !key.currentState!.isLocked) {
          spinFutures.add(key.currentState!.spin());
        }
      }
    }

    // Wait for all spins to complete (they auto-lock now)
    await Future.wait(spinFutures);

    setState(() {
      _isSpinning = false;
    });
  }

  /// Validates all wheels have input and generates the pitch.
  Future<void> _generatePitch() async {
    if (_isGeneratingPitch) return;

    // Validate all wheels have selected input
    for (final category in wheelCategories) {
      final wheelCount = _wheelCounts[category.id]!;
      final keys = _wheelKeys[category.id]!;

      for (int i = 0; i < wheelCount; i++) {
        final key = keys[i];
        if (key.currentState != null && !key.currentState!.hasSelectedInput) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please spin or lock all ${category.displayName} wheels before generating.',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
      }
    }

    // Collect all selections
    final Map<String, List<String>> selections = {};
    for (final category in wheelCategories) {
      final wheelCount = _wheelCounts[category.id]!;
      final keys = _wheelKeys[category.id]!;
      selections[category.id] = [];

      for (int i = 0; i < wheelCount; i++) {
        final key = keys[i];
        if (key.currentState != null) {
          selections[category.id]!.add(key.currentState!.selectedItem);
        }
      }
    }

    setState(() {
      _isGeneratingPitch = true;
    });

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GeneratingPitchDialog(
            selections: selections,
            categoryColors: categoryColors,
          ),
    );

    // Generate pitch from API
    try {
      final result = await _apiService.generatePitch(
        characters: selections['characters'] ?? [],
        creatives: selections['creatives'] ?? [],
        locations: selections['locations'] ?? [],
        genres: selections['genres'] ?? [],
      );

      // Dismiss the loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      setState(() {
        _isGeneratingPitch = false;
      });

      if (mounted) {
        _navigateToPitchResult(result, selections);
      }
    } catch (e) {
      // Dismiss the loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      setState(() {
        _isGeneratingPitch = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate pitch: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _navigateToPitchResult(
    PitchResult result,
    Map<String, List<String>> selections,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PitchResultScreen(
              result: result,
              selections: selections,
              onPlayAgain: () {
                Navigator.of(context).pop();
                _resetWheels();
              },
            ),
      ),
    );
  }

  void _resetWheels() {
    for (final category in wheelCategories) {
      final wheelCount = _wheelCounts[category.id]!;
      final keys = _wheelKeys[category.id]!;

      for (int i = 0; i < wheelCount; i++) {
        keys[i].currentState?.reset();
      }
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.95),
              Color.lerp(
                theme.colorScheme.surface,
                theme.colorScheme.primary,
                0.1,
              )!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Text(
                      '🎬 Movie Pitch Generator',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Spin the wheels to generate your next blockbuster!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Wheel categories
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: wheelCategories.length,
                  itemBuilder: (context, index) {
                    final category = wheelCategories[index];
                    return WheelCategorySection(
                      category: category,
                      currentWheelCount: _wheelCounts[category.id]!,
                      wheelKeys: _wheelKeys[category.id]!.sublist(
                        0,
                        _wheelCounts[category.id]!,
                      ),
                      onAddWheel: () => _addWheel(category.id),
                      onRemoveWheel: () => _removeWheel(category.id),
                      accentColor:
                          categoryColors[index % categoryColors.length],
                    );
                  },
                ),
              ),

              // Action buttons (Spin & Generate)
              Padding(
                padding: const EdgeInsets.all(24),
                child: ActionButtons(
                  onSpinPressed: _spinWheels,
                  onGeneratePressed: _generatePitch,
                  isSpinning: _isSpinning,
                  isGenerating: _isGeneratingPitch,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
