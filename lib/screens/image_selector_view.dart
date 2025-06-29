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
import 'package:story_genie/widgets/shared/scrollable_column.dart';
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
      //Top-App Bar starts here
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.semiBold24.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bidPry500,
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      //body starts here
      body: ScrollableColumn(
        padding: EdgeInsets.all(24),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //---------
          Text(
            'Upload the Subject Image',
            style: AppTextStyles.medium18.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          //---------
          Spacing.vertSmall(),
          //---------
          UploadImageCard(
            onTap: () async {
              final fromGallery = await const ImageSourceDialog().show(context);
              if (fromGallery == null) return;
              image = await MediaService().pickImage(fromGallery: fromGallery);
              setState(() {});
            },
          ),
          //------------------
          if (image != null)
            Container(
              width: double.maxFinite,
              margin: REdgeInsets.only(top: 16),
              padding: REdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.bidPry600, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.file(image!, fit: BoxFit.cover),
            ),
          Spacing.vertRegular(),
          //------------------------
          AppDropdownField(
            label: 'Genre',
            hint: 'Select Genre',
            items: AppConstants.genres,
            value: genre,
            onChanged: (val) => genre = val!,
          ),
          Spacing.vertRegular(),
          //-------------------------
          AppDropdownField(
            label: 'Story Length',
            hint: 'Select Length',
            items: AppConstants.storyLength,
            value: length,
            onChanged: (val) => length = val!,
          ),
          Spacing.vertRegular(),
          //--------------------------
          AppButton(
            label: 'Generate Story',
            isBusy: isBusy,
            onPressed: () async {
              try {
                setState(() => isBusy = true);
                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please Select an image')),
                  );
                  return;
                }
                final items = await _aiService.getItemsFromImage(image!);
                if (items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No Item found in this image, please try again',
                      ),
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
                    builder:
                        (_) => StoryView(image: image!, storyParams: params),
                  ),
                );
              } on IFailure catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.message)));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              } finally {
                setState(() => isBusy = false);
              }
            },
          ),
        ],
      ),
    );
  }
}
