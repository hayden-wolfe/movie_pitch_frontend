import 'package:flutter/material.dart';

/// A widget displaying "Spin" and "Generate" action buttons.
class ActionButtons extends StatelessWidget {
  final VoidCallback? onSpinPressed;
  final VoidCallback? onGeneratePressed;
  final bool isSpinning;
  final bool isGenerating;

  const ActionButtons({
    super.key,
    required this.onSpinPressed,
    required this.onGeneratePressed,
    this.isSpinning = false,
    this.isGenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spin Button
        _ActionButton(
          label: 'SPIN',
          icon: Icons.casino,
          onPressed: (isSpinning || isGenerating) ? null : onSpinPressed,
          isLoading: isSpinning,
          gradientColors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          theme: theme,
        ),
        const SizedBox(width: 16),
        // Generate Button
        _ActionButton(
          label: 'GENERATE',
          icon: Icons.movie_creation,
          onPressed: (isSpinning || isGenerating) ? null : onGeneratePressed,
          isLoading: isGenerating,
          gradientColors: [
            const Color(0xFF00B894), // Emerald green
            const Color(0xFF55EFC4), // Light mint
          ],
          theme: theme,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color> gradientColors;
  final ThemeData theme;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isLoading,
    required this.gradientColors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors:
              isEnabled
                  ? gradientColors
                  : [
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                  ],
        ),
        boxShadow:
            isEnabled
                ? [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child:
                isLoading
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: theme.colorScheme.onPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
