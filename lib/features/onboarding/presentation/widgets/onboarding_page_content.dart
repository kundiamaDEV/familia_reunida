import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.12),

            Expanded(
              child: Center(
                child: _OnboardingIllustration(
                  icon: icon,
                  iconBackgroundColor: iconBackgroundColor,
                ),
              ),
            ),

            const SizedBox(height: 36),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.55,
              ),
            ),

            SizedBox(height: screenHeight * 0.20),
          ],
        ),
      ),
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({
    required this.icon,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: .06),
            ),
          ),

          Positioned(
            top: 12,
            right: 22,
            child: _DecorativePoint(
              size: 22,
              color: AppColors.secondary.withValues(alpha: .28),
            ),
          ),

          Positioned(
            bottom: 22,
            left: 16,
            child: _DecorativePoint(
              size: 30,
              color: AppColors.primary.withValues(alpha: .12),
            ),
          ),

          Positioned(
            top: 56,
            left: 10,
            child: _DecorativePoint(
              size: 12,
              color: AppColors.secondary.withValues(alpha: .50),
            ),
          ),

          Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: .80),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .12),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(icon, size: 82, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _DecorativePoint extends StatelessWidget {
  const _DecorativePoint({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
