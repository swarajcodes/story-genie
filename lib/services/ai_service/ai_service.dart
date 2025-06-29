import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:logger/web.dart';
import 'package:story_genie/models/failure.dart';
import 'package:story_genie/models/story_params.dart';
import 'package:story_genie/services/ai_service/i_ai_service.dart';
import 'package:story_genie/models/item_data.dart';

class AIService extends IAIService {
  final _log = Logger();

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  static const listPrompt =
      '''In this image, identify and label only the focused and important visible objects with a confidence score above 70%. Return the results as a JSON object with the following structure:'''
      '''{"name": "object name", "description": "object description"}''';

  @override
  Future<List<String>> getItemsFromImage(File image) async {
    try {
      final imageBytes = await image.readAsBytes();

      final content = [
        Content.multi([
          TextPart(listPrompt),
          InlineDataPart('image/png', imageBytes),
        ]),
      ];

      final res = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 30));
      final responseText = res.text;

      // Remove markdown code block markers if present
      final cleanedResponse =
          responseText?.replaceAll(RegExp(r'```json|```'), '').trim();

      _log.d(cleanedResponse);

      // Try to decode JSON from the cleaned response
      final parsedRes = jsonDecode(cleanedResponse ?? '');
      final data = (parsedRes as List).map((e) => ItemData.fromMap(e)).toList();

      return data.map((e) => e.value).toList();
    } on TimeoutException {
      throw InternetFailure();
    } catch (e, s) {
      _log.e(e, stackTrace: s);
      throw Failure(
        message: 'Something went wrong identifying items. Try again.',
        data: e,
      );
    }
  }

  @override
  Stream<String> streamStoryDetail(StoryParams storyParams) async* {
    try {
      String prompt =
          'Create a story from items in this list: ${storyParams.items}. '
          'The story should be a ${storyParams.genre} story. Use Easy english for the task and simple story.'
          'The story MUST be ${storyParams.parsedLength} long. '
          'Return the story as plain text only, without any markdown formatting, asterisks, or special characters for formatting.';

      final content = [Content.text(prompt)];

      // FirebaseAI may not support streaming exactly as Google Generative AI does
      // If not, just yield the response as a single chunk
      final res = await model.generateContent(content);
      yield res.text ?? 'No story generated.';
    } catch (e, s) {
      _log.e(e, stackTrace: s);
      yield 'Something went wrong generating your story. Try again later';
    }
  }

  @override
  Future<String> fetchStoryDetail(StoryParams storyParams) async {
    try {
      String prompt =
          'Create a story from items in this list: ${storyParams.items}.';
      prompt += 'The story should be a ${storyParams.genre} story.';
      prompt += 'The story MUST be ${storyParams.parsedLength} long.';
      final content = [Content.text(prompt)];

      final response = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 30));

      _log.d(response.text);
      return response.text ?? 'No story generated.';
    } on TimeoutException {
      throw InternetFailure();
    } catch (e, s) {
      _log.e(e, stackTrace: s);
      throw Failure(
        message: 'Something went wrong generating your story. Try again later',
        data: e,
      );
    }
  }
}
