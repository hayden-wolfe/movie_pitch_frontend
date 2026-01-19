import 'package:flutter/material.dart';

/// An animated spin button with loading state.
class SpinButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SpinButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors:
              onPressed != null
                  ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                  : [
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                  ],
        ),
        boxShadow:
            onPressed != null
                ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
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
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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
                          Icons.casino,
                          color: theme.colorScheme.onPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'SPIN',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
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
