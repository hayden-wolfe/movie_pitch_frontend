import 'dart:math';
import 'package:flutter/material.dart';

/// A spinning wheel widget that can be controlled externally.
///
/// Use `GlobalKey<SpinningWheelState>` to call `spin()` from a parent widget.
/// Supports locking (prevents spinning) and editing (manual text input).
class SpinningWheel extends StatefulWidget {
  final List<String> items;
  final double itemExtent;
  final ValueChanged<String>? onSpinComplete;
  final Color? accentColor;

  const SpinningWheel({
    super.key,
    required this.items,
    this.itemExtent = 60.0,
    this.onSpinComplete,
    this.accentColor,
  });

  @override
  State<SpinningWheel> createState() => SpinningWheelState();
}

class SpinningWheelState extends State<SpinningWheel>
    with AutomaticKeepAliveClientMixin {
  late FixedExtentScrollController _controller;
  late TextEditingController _textController;

  // Track the locked position separately to preserve visual state
  int _lockedPosition = 0;
  bool _isSpinning = false;
  bool _isLocked = false;
  bool _isEditing = false;

  @override
  bool get wantKeepAlive => true;

  /// Gets the current wheel index from the controller.
  int get _currentWheelIndex {
    if (_isLocked) {
      return _lockedPosition % widget.items.length;
    }
    if (_controller.hasClients) {
      return _controller.selectedItem % widget.items.length;
    }
    return 0;
  }

  /// The currently selected item.
  /// Returns the text field value if in edit mode, otherwise the wheel's current item.
  String get selectedItem {
    if (_isEditing) {
      return _textController.text;
    }
    return widget.items[_currentWheelIndex];
  }

  /// Whether the wheel is currently spinning.
  bool get isSpinning => _isSpinning;

  /// Whether the wheel is locked (won't spin).
  bool get isLocked => _isLocked;

  /// Whether the wheel is in edit mode.
  bool get isEditing => _isEditing;

  /// Returns true if in edit mode with empty text.
  bool get hasEmptyEditText =>
      _isEditing && _textController.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: 0);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Triggers the wheel to spin to a random item.
  /// Returns a Future that completes with the selected item.
  /// If locked or in edit mode, returns current value without spinning.
  Future<String> spin() async {
    // If in edit mode, return the text (validation should be done by caller)
    if (_isEditing) {
      return _textController.text;
    }

    // If locked, return current value without spinning
    if (_isLocked) {
      return selectedItem;
    }

    if (widget.items.isEmpty || _isSpinning) {
      return selectedItem;
    }

    setState(() {
      _isSpinning = true;
    });

    final int itemCount = widget.items.length;
    final int randomIndex = Random().nextInt(itemCount);
    final int currentPosition = _controller.selectedItem;
    final int extraLoops = 3 + Random().nextInt(3); // 3-5 full loops
    final int targetIndex =
        currentPosition +
        (extraLoops * itemCount) +
        (randomIndex - (currentPosition % itemCount) + itemCount) % itemCount;

    await _controller.animateToItem(
      targetIndex,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.easeOutCubic,
    );

    setState(() {
      _isSpinning = false;
    });

    final result = widget.items[randomIndex];
    widget.onSpinComplete?.call(result);
    return result;
  }

  /// Resets the wheel to its initial position.
  void reset() {
    _controller.jumpToItem(0);
    setState(() {
      _lockedPosition = 0;
      _textController.text = '';
      _isLocked = false;
      _isEditing = false;
    });
  }

  void _toggleLock() {
    if (!_isLocked) {
      // Locking: save the current position
      _lockedPosition = _controller.hasClients ? _controller.selectedItem : 0;
    } else {
      // Unlocking: restore the controller to the locked position
      if (_controller.hasClients) {
        _controller.jumpToItem(_lockedPosition);
      }
    }
    setState(() {
      _isLocked = !_isLocked;
    });
  }

  void _toggleEdit() {
    setState(() {
      if (!_isEditing) {
        // Entering edit mode - start with empty text field
        _textController.text = '';
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final theme = Theme.of(context);
    final accentColor = widget.accentColor ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Controls row (lock and edit)
        _buildControlsRow(theme, accentColor),
        const SizedBox(height: 8),
        // Wheel or text input
        _isEditing
            ? _buildEditInput(theme, accentColor)
            : _isLocked
            ? _buildLockedDisplay(theme, accentColor)
            : _buildWheel(theme, accentColor),
      ],
    );
  }

  Widget _buildControlsRow(ThemeData theme, Color accentColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lock button
        _buildIconButton(
          icon: _isLocked ? Icons.lock : Icons.lock_open,
          isActive: _isLocked,
          onTap: _toggleLock,
          theme: theme,
          accentColor: accentColor,
          tooltip: _isLocked ? 'Unlock wheel' : 'Lock wheel',
        ),
        const SizedBox(width: 8),
        // Edit button - toggles between wheel and text input
        _buildIconButton(
          icon: Icons.edit,
          isActive: _isEditing,
          onTap: _toggleEdit,
          theme: theme,
          accentColor: accentColor,
          tooltip: _isEditing ? 'Use wheel' : 'Enter manually',
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required ThemeData theme,
    required Color accentColor,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isActive
                    ? accentColor.withValues(alpha: 0.3)
                    : theme.colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isActive ? accentColor : accentColor.withValues(alpha: 0.3),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                isActive
                    ? accentColor
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildEditInput(ThemeData theme, Color accentColor) {
    return Container(
      height: 220,
      width: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _textController,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter text here',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ),
          ),
          // Edit mode indicator
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 14,
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays a static locked view showing the selected item
  Widget _buildLockedDisplay(ThemeData theme, Color accentColor) {
    final lockedItem = widget.items[_lockedPosition % widget.items.length];

    return Container(
      height: 220,
      width: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Locked overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          // Centered locked item display
          Center(
            child: Container(
              height: widget.itemExtent - 8,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Text(
                lockedItem,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Lock icon overlay
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  size: 14,
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel(ThemeData theme, Color accentColor) {
    return Container(
      height: 220,
      width: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
            accentColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // The wheel
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: widget.itemExtent,
              physics: const FixedExtentScrollPhysics(),
              diameterRatio: 1.3,
              squeeze: 0.95,
              overAndUnderCenterOpacity: 0.4,
              useMagnifier: true,
              magnification: 1.15,
              childDelegate: ListWheelChildLoopingListDelegate(
                children:
                    widget.items.map((item) {
                      return Center(
                        child: Container(
                          height: widget.itemExtent - 8,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            item,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          // Center indicator
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  height: widget.itemExtent,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: accentColor, width: 2),
                      bottom: BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
