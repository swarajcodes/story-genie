import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_genie/models/failure.dart';
import 'package:story_genie/models/story_params.dart';

import 'package:story_genie/services/ai_service/ai_service.dart';
import 'package:story_genie/services/ai_service/i_ai_service.dart';

import 'package:story_genie/core/app_textstyles.dart';
import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/widgets/shared/spacing.dart';
import 'package:story_genie/widgets/app_loader.dart';
import 'package:story_genie/widgets/app_button.dart';
import 'package:story_genie/widgets/story_share_button.dart';
import 'package:story_genie/widgets/story_title_display.dart';

class StoryView extends StatefulWidget {
  final File image;
  final StoryParams storyParams;

  const StoryView({super.key, required this.image, required this.storyParams});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final IAIService _aiService = AIService();
  bool isBusy = false;
  IFailure? failure;
  String story = '';
  String storyTitle = '';

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      setState(() => isBusy = true);

      // Generate story title first
      storyTitle = await _aiService.generateStoryTitle(
        widget.storyParams.items,
        widget.storyParams.genre,
      );

      // Generate the story
      story = await _aiService.fetchStoryDetail(widget.storyParams);
    } on IFailure catch (e) {
      failure = e;
    } finally {
      setState(() => isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Padding(
          padding: REdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: REdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              Spacing.horizRegular(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Story Genie',
                    style: AppTextStyles.medium20.copyWith(
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'AI Story Generator',
                    style: AppTextStyles.regular14.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80.h,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.bidPry500,
                AppColors.bidPry600,
                AppColors.bidPry800,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.bidPry500.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        actions: [
          // Share button
          if (story.isNotEmpty && !isBusy)
            Container(
              margin: REdgeInsets.only(right: 8, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: StoryShareButton(
                story: story,
                genre: widget.storyParams.genre,
                onShare: () {
                  // You can add analytics or additional logic here
                  print('Story shared!');
                },
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: REdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.bidPry500, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.bidPry500.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Padding(
                padding: REdgeInsets.all(20),
                child: Builder(
                  builder: (context) {
                    if (isBusy) {
                      return SizedBox(
                        height: 100.h,
                        child: const Center(
                          child: AppLoader(color: AppColors.bidPry400),
                        ),
                      );
                    }
                    if (failure != null && storyTitle.isEmpty) {
                      return SizedBox(
                        height: 100.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 32.sp,
                                color: Colors.red,
                              ),
                              Spacing.vertSmall(),
                              Text(
                                'Failed to generate title',
                                style: AppTextStyles.medium16,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return storyTitle.isNotEmpty
                        ? StoryTitleDisplay(
                          title: storyTitle,
                          genre: widget.storyParams.genre,
                        )
                        : const SizedBox.shrink();
                  },
                ),
              ),

              // Image Section
              Container(
                width: double.infinity,
                height: 200.h,
                margin: REdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Builder(
                    builder: (context) {
                      if (isBusy) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: AppLoader(color: AppColors.bidPry400),
                          ),
                        );
                      }
                      return Image.file(
                        widget.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
              ),

              // Story Content Section
              Padding(
                padding: REdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Builder(
                  builder: (context) {
                    if (isBusy) {
                      return SizedBox(
                        height: 200.h,
                        child: const Center(
                          child: AppLoader(color: AppColors.bidPry400),
                        ),
                      );
                    }
                    if (failure != null && story.isEmpty) {
                      return SizedBox(
                        height: 200.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48.sp,
                                color: Colors.red,
                              ),
                              Spacing.vertSmall(),
                              Text(
                                'Failed to generate story',
                                style: AppTextStyles.medium16,
                              ),
                              Spacing.vertSmall(),
                              AppButton(
                                label: 'Try Again',
                                isCollapsed: true,
                                onPressed: () => _fetchStory(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return DefaultTextStyle(
                      style: AppTextStyles.regular16.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.6,
                      ),
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            story,
                            speed: const Duration(milliseconds: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
