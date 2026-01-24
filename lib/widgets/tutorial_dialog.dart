import 'package:flutter/material.dart';

/// A dialog that displays an introduction and tutorial for the app.
/// Responsive layout: single column on small screens, two columns on larger screens.
class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  final lockDescription =
      'Tap the lock icon to keep your current selection. Locked wheels won\'t spin when you press SPIN, so lock in your favorites!';
  final editDescription =
      'Tap the edit icon to type your own custom entry instead of using the wheel. Great for crafting your own unique movie pitches!';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 48 : 16,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWideScreen ? 700 : 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                Color.lerp(
                  theme.colorScheme.surface,
                  theme.colorScheme.primary,
                  0.08,
                )!,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(theme),
                  const SizedBox(height: 24),

                  // Content - responsive layout
                  if (isWideScreen)
                    _buildWideContent(theme)
                  else
                    _buildNarrowContent(theme),

                  const SizedBox(height: 24),

                  // Close button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Got it!'),
                      style: TextButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.3),
                theme.colorScheme.secondary.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text('🎬', style: theme.textTheme.headlineMedium),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Use',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Movie Pitch Generator',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWideContent(ThemeData theme) {
    return Column(
      children: [
        // Introduction
        _buildIntroSection(theme),
        const SizedBox(height: 20),
        // Two columns for Lock and Edit
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFeatureCard(
                theme: theme,
                icon: Icons.lock,
                iconColor: const Color(0xFFFFE66D),
                title: 'Lock',
                description: lockDescription,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureCard(
                theme: theme,
                icon: Icons.edit,
                iconColor: const Color(0xFF4ECDC4),
                title: 'Edit',
                description: editDescription,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // About section
        _buildAboutSection(theme),
      ],
    );
  }

  Widget _buildNarrowContent(ThemeData theme) {
    return Column(
      children: [
        _buildIntroSection(theme),
        const SizedBox(height: 16),
        _buildFeatureCard(
          theme: theme,
          icon: Icons.lock,
          iconColor: const Color(0xFFFFE66D),
          title: 'Lock',
          description: lockDescription,
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          theme: theme,
          icon: Icons.edit,
          iconColor: const Color(0xFF4ECDC4),
          title: 'Edit',
          description: editDescription,
        ),
        const SizedBox(height: 16),
        _buildAboutSection(theme),
      ],
    );
  }

  Widget _buildIntroSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.movie_creation_outlined,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Spin the wheels to randomly select movie elements, then generate a unique pitch using AI!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAboutBullet(
            theme,
            '🎬',
            'I\'ve always loved movies and brainstorming wild movie ideas, so I built this app to generate crazy pitches and showcase my full-stack development skills.',
          ),
          const SizedBox(height: 8),
          _buildAboutBullet(
            theme,
            '🎡',
            'The wheels feature some of my favorite actors, people, and places; plus a few goofy additions for fun.',
          ),
          const SizedBox(height: 8),
          _buildAboutBullet(
            theme,
            '📱',
            'The frontend is built with Flutter for a smooth, cross-platform experience.',
          ),
          const SizedBox(height: 8),
          _buildAboutBullet(
            theme,
            '⚡',
            'The backend runs on FastAPI with PydanticAI and OpenAI\'s API, hosted on a Linux server via nginx and a Cloudflare Tunnel.',
          ),
          const SizedBox(height: 8),
          _buildAboutBullet(
            theme,
            '💻',
            'This project is open source! Check out my GitHub for both the frontend and backend repos.',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutBullet(ThemeData theme, String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
