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
        padding: REdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.bidPry500, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.image, color: AppColors.bidPry500),
            Spacing.vertRegular(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Click to upload',
                    style: AppTextStyles.semiBold14.copyWith(
                      color: AppColors.bidPry800,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vertTiny(),
            Text(
              'PNG, JPG or JPEG',
              style: AppTextStyles.regular12.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
