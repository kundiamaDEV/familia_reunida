import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WelcomeFamilyIllustration extends StatelessWidget {
  const WelcomeFamilyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 270,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 34,
            child: _DecorativeCircle(
              size: 24,
              color: AppColors.secondary.withValues(alpha: 0.32),
            ),
          ),
          Positioned(
            top: 92,
            left: 18,
            child: _DecorativeCircle(
              size: 14,
              color: AppColors.secondary.withValues(alpha: 0.55),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 38,
            child: _DecorativeCircle(
              size: 34,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 46,
            child: Container(
              width: 178,
              height: 178,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF4E3B8),
                border: Border.all(color: AppColors.secondary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 74,
            child: Icon(
              Icons.family_restroom_rounded,
              size: 110,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            bottom: 6,
            child: Container(
              width: 184,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'Sempre ligados',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

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
