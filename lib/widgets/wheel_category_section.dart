import 'package:flutter/material.dart';
import 'package:movie_pitch_generator/models/wheel_category.dart';
import 'package:movie_pitch_generator/widgets/spinning_wheel.dart';

/// A section displaying a single category with its wheels and add/remove controls.
/// Uses AutomaticKeepAliveClientMixin to preserve state when scrolled off-screen.
class WheelCategorySection extends StatefulWidget {
  final WheelCategory category;
  final int currentWheelCount;
  final List<GlobalKey<SpinningWheelState>> wheelKeys;
  final VoidCallback onAddWheel;
  final VoidCallback onRemoveWheel;
  final Color accentColor;

  const WheelCategorySection({
    super.key,
    required this.category,
    required this.currentWheelCount,
    required this.wheelKeys,
    required this.onAddWheel,
    required this.onRemoveWheel,
    required this.accentColor,
  });

  @override
  State<WheelCategorySection> createState() => _WheelCategorySectionState();
}

class _WheelCategorySectionState extends State<WheelCategorySection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final theme = Theme.of(context);
    final canAdd = widget.currentWheelCount < widget.category.maxWheels;
    final canRemove = widget.currentWheelCount > widget.category.minWheels;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.displayName,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: widget.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildControlButton(
                    icon: Icons.remove,
                    onPressed: canRemove ? widget.onRemoveWheel : null,
                    theme: theme,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${widget.currentWheelCount} / ${widget.category.maxWheels}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                  _buildControlButton(
                    icon: Icons.add,
                    onPressed: canAdd ? widget.onAddWheel : null,
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Wheels row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.currentWheelCount, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < widget.currentWheelCount - 1 ? 12 : 0,
                  ),
                  child: SpinningWheel(
                    key: widget.wheelKeys[index],
                    items: widget.category.items,
                    accentColor: widget.accentColor,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required ThemeData theme,
  }) {
    final isEnabled = onPressed != null;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isEnabled
                ? widget.accentColor.withValues(alpha: 0.2)
                : theme.colorScheme.surface.withValues(alpha: 0.3),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color:
              isEnabled
                  ? widget.accentColor
                  : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        onPressed: onPressed,
        iconSize: 20,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}
