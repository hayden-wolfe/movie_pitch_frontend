import 'package:flutter/material.dart';
import 'dart:ui';

/// A dialog showing the loading state while generating a movie pitch.
/// Displays the selected wheel values and a spinning indicator.
class GeneratingPitchDialog extends StatelessWidget {
  final Map<String, List<String>> selections;
  final List<Color> categoryColors;

  const GeneratingPitchDialog({
    super.key,
    required this.selections,
    required this.categoryColors,
  });

  static const List<String> categoryOrder = [
    'characters',
    'creatives',
    'locations',
    'genres',
  ];

  static const Map<String, String> categoryDisplayNames = {
    'characters': 'Characters',
    'creatives': 'Creatives',
    'locations': 'Locations',
    'genres': 'Genres',
  };

  static const Map<String, IconData> categoryIcons = {
    'characters': Icons.person,
    'creatives': Icons.movie_filter,
    'locations': Icons.location_on,
    'genres': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with spinning animation
                  _buildHeader(theme),
                  const SizedBox(height: 24),

                  // Selected values
                  _buildSelectionsGrid(theme),
                  const SizedBox(height: 24),

                  // Loading indicator
                  _buildLoadingIndicator(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          '🎬 Your Movie Pitch',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s what we\'re working with...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionsGrid(ThemeData theme) {
    return Column(
      children:
          categoryOrder.asMap().entries.map((entry) {
            final index = entry.key;
            final categoryId = entry.value;
            final items = selections[categoryId] ?? [];
            final color = categoryColors[index % categoryColors.length];
            final displayName = categoryDisplayNames[categoryId] ?? categoryId;
            final icon = categoryIcons[categoryId] ?? Icons.label;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCategoryRow(
                theme: theme,
                displayName: displayName,
                icon: icon,
                items: items,
                color: color,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCategoryRow({
    required ThemeData theme,
    required String displayName,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          // Category name and values
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children:
                      items.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: color.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Generating your pitch...',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
