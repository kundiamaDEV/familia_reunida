import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FamilySetupOptionCard extends StatelessWidget {
  const FamilySetupOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onTap,
    this.isPrimary = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? AppColors.primary : AppColors.surface;

    final foregroundColor = isPrimary ? AppColors.white : AppColors.textPrimary;

    final secondaryTextColor = isPrimary
        ? AppColors.white.withValues(alpha: 0.76)
        : AppColors.textSecondary;

    final iconBackgroundColor = isPrimary
        ? AppColors.white.withValues(alpha: 0.14)
        : AppColors.primary.withValues(alpha: 0.08);

    final iconColor = isPrimary ? AppColors.secondaryLight : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: isPrimary
                ? null
                : Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.07),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: 29),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                description,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    actionLabel,
                    style: TextStyle(
                      color: isPrimary ? AppColors.white : AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isPrimary
                          ? AppColors.white.withValues(alpha: 0.14)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: isPrimary ? AppColors.white : AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
