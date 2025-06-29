import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/core/app_textstyles.dart';
import 'package:story_genie/widgets/shared/spacing.dart';

class StoryTitleDisplay extends StatelessWidget {
  final String title;
  final String genre;

  const StoryTitleDisplay({
    super.key,
    required this.title,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      margin: REdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bidPry500,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.semiBold18.copyWith(color: Colors.white),
          ),
          Spacing.vertSmall(),
          Text(
            genre,
            style: AppTextStyles.regular12.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
