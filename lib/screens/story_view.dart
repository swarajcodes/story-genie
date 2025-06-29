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
import 'package:story_genie/widgets/shared/scrollable_column.dart';
import 'package:story_genie/widgets/shared/spacing.dart';
import 'package:story_genie/widgets/app_loader.dart';
import 'package:story_genie/widgets/app_button.dart';

class StoryView extends StatefulWidget {
  final File image;
  final StoryParams storyParams;

  const StoryView({Key? key, required this.image, required this.storyParams})
    : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final IAIService _aiService = AIService();
  bool isBusy = false;
  IFailure? failure;
  String story = '';

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      setState(() => isBusy = true);
      String prompt =
          'Create a story from items in this list: ${widget.storyParams.items}. '
          'The story should be a ${widget.storyParams.genre} story. '
          'The story MUST be ${widget.storyParams.parsedLength} long. '
          'Return the story as plain text only, without any markdown formatting, asterisks, or special characters for formatting.';
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
      appBar: AppBar(
        title: Text(
          "Here's your ${widget.storyParams.genre.toLowerCase()} story",
          style: AppTextStyles.semiBold16,
        ),
        centerTitle: true,
      ),
      body: ScrollableColumn(
        children: [
          Image.file(widget.image, fit: BoxFit.cover),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: REdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  if (isBusy) {
                    return const Center(
                      child: AppLoader(color: AppColors.bidPry400),
                    );
                  }
                  if (failure != null && story.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Try again'),
                          Spacing.vertRegular(),
                          AppButton(
                            label: 'Refresh',
                            isCollapsed: true,
                            onPressed: () => _fetchStory(),
                          ),
                        ],
                      ),
                    );
                  }

                  return DefaultTextStyle(
                    style: AppTextStyles.regular14.copyWith(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.white
                              : AppColors.black,
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
          ),
        ],
      ),
    );
  }
}
