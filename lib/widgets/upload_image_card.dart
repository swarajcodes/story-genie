import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/core/app_textstyles.dart';
import 'package:story_genie/widgets/shared/spacing.dart';

class UploadImageCard extends StatelessWidget {
  final VoidCallback onTap;
  const UploadImageCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: REdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.bidPry500.withValues(alpha: 0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.bidPry500.withValues(alpha: 0.02),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bidPry500.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.bidPry500,
                size: 32.sp,
              ),
            ),
            Spacing.vertRegular(),
            Text(
              'Tap to Upload Image',
              style: AppTextStyles.semiBold16.copyWith(
                color: AppColors.bidPry500,
              ),
            ),
            Spacing.vertSmall(),
            Text(
              'PNG, JPG or JPEG • Max 10MB',
              style: AppTextStyles.regular12.copyWith(color: AppColors.gray500),
            ),
            Spacing.vertSmall(),
            Container(
              padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bidPry500.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '📱 Camera or 📁 Gallery',
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.bidPry500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
