import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_genie/core/app_colours.dart';
import 'package:story_genie/core/app_constants.dart';
import 'package:story_genie/core/app_textstyles.dart';
import 'package:story_genie/models/failure.dart';
import 'package:story_genie/models/story_params.dart';
import 'package:story_genie/screens/story_view.dart';
import 'package:story_genie/services/media_service/media_service.dart';
import 'package:story_genie/widgets/app_button.dart';
import 'package:story_genie/widgets/app_dropdown_field.dart';
import 'package:story_genie/widgets/shared/spacing.dart';
import 'package:story_genie/widgets/upload_image_card.dart';
import 'package:story_genie/widgets/image_source_dialog.dart';
import 'package:story_genie/services/ai_service/i_ai_service.dart';
import 'package:story_genie/services/ai_service/ai_service.dart';

class ImageSelectorView extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? themeMode;

  const ImageSelectorView({super.key, this.onToggleTheme, this.themeMode});

  @override
  State<ImageSelectorView> createState() => _ImageSelectorViewState();
}

class _ImageSelectorViewState extends State<ImageSelectorView> {
  final IAIService _aiService = AIService();
  File? image;
  String genre = AppConstants.genres.first;
  String length = AppConstants.storyLength.first;
  bool isBusy = false;

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
                    AppConstants.appName,
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
          Container(
            margin: REdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                widget.themeMode == ThemeMode.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
                color: Colors.white,
                size: 22.sp,
              ),
              tooltip: 'Toggle Theme',
              onPressed: widget.onToggleTheme,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: REdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),
            Spacing.vertRegular(),

            // Upload Section
            _buildUploadSection(),
            Spacing.vertRegular(),

            // Settings Section
            _buildSettingsSection(),
            Spacing.vertRegular(),

            // Generate Button
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bidPry500.withValues(alpha: 0.1),
            AppColors.bidPry500.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_stories, size: 48.sp, color: AppColors.bidPry500),
          Spacing.vertSmall(),
          Text(
            'Transform Your Images Into Stories',
            style: AppTextStyles.medium20.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.vertSmall(),
          Text(
            'Upload any image and let AI create a captivating story for you',
            style: AppTextStyles.regular14.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📸 Upload Your Image',
          style: AppTextStyles.semiBold18.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Spacing.vertSmall(),
        Text(
          'Choose an image that inspires you',
          style: AppTextStyles.regular14.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Spacing.vertSmall(),
        UploadImageCard(
          onTap: () async {
            final fromGallery = await const ImageSourceDialog().show(context);
            if (fromGallery == null) return;
            image = await MediaService().pickImage(fromGallery: fromGallery);
            setState(() {});
          },
        ),
        if (image != null) ...[
          Spacing.vertSmall(),
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.bidPry500.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.bidPry500.withValues(alpha: 0.05),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                    Spacing.horizSmall(),
                    Text(
                      'Image Selected',
                      style: AppTextStyles.medium14.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Spacing.vertSmall(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                    height: 120.h,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚙️ Story Settings',
          style: AppTextStyles.semiBold18.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Spacing.vertSmall(),
        Text(
          'Customize your story preferences',
          style: AppTextStyles.regular14.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Spacing.vertSmall(),
        Container(
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              AppDropdownField(
                label: '🎭 Genre',
                hint: 'Select Genre',
                items: AppConstants.genres,
                value: genre,
                onChanged: (val) => setState(() => genre = val!),
              ),
              Spacing.vertRegular(),
              AppDropdownField(
                label: '📏 Story Length',
                hint: 'Select Length',
                items: AppConstants.storyLength,
                value: length,
                onChanged: (val) => setState(() => length = val!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(vertical: 8),
      child: AppButton(
        label: isBusy ? 'Generating Story...' : '✨ Generate Story',
        isBusy: isBusy,
        onPressed: () async {
          try {
            setState(() => isBusy = true);
            if (image == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select an image first'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            final items = await _aiService.getItemsFromImage(image!);
            if (items.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'No items found in this image. Please try a different image.',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            final params = StoryParams(
              items: items,
              genre: genre,
              length: length,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StoryView(image: image!, storyParams: params),
              ),
            );
          } on IFailure catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Something went wrong. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            setState(() => isBusy = false);
          }
        },
      ),
    );
  }
}
