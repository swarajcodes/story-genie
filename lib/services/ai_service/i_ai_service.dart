import 'dart:io';

import 'package:story_genie/models/story_params.dart';

abstract class IAIService {
  Future<List<String>> getItemsFromImage(File image);

  Stream<String> streamStoryDetail(StoryParams storyParams);

  Future<String> fetchStoryDetail(StoryParams storyParams);

  // New methods for enhanced features
  Future<String> generateStoryTitle(List<String> items, String genre);

  Future<String> continueStory(String existingStory, String direction);
}
