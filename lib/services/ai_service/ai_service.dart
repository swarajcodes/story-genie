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

  static const enhancedImagePrompt = '''
Analyze this image and identify the main objects, characters, setting, mood, and visual elements that would be interesting for storytelling.
Focus on items that would create engaging narratives.

Return the results as a JSON array with the following structure:
[
  {
    "name": "object name",
    "description": "detailed description of the object and its role in storytelling"
  }
]

Only include items with confidence above 70% and focus on storytelling-relevant elements.
Consider characters, objects, settings, emotions, and atmospheric elements.
''';

  String _buildStoryPrompt(StoryParams storyParams) {
    return '''
Create an engaging ${storyParams.genre} story based on these elements: ${storyParams.items.join(', ')}.

Requirements:
- Genre: ${storyParams.genre}
- Length: ${storyParams.parsedLength}
- Style: Engaging, descriptive, and age-appropriate
- Include character development and dialogue
- Create a clear beginning, middle, and end
- Use vivid descriptions and sensory details
- Make the story emotionally engaging

Story Guidelines:
- Start with a compelling hook that draws readers in
- Develop characters with distinct personalities and motivations
- Include meaningful dialogue that advances the plot
- Create tension and build toward a satisfying resolution
- End with a conclusion that feels complete
- Use descriptive language to paint vivid scenes
- Include sensory details (sight, sound, smell, touch, taste)
- Keep the story concise and focused

Return the story as plain text without any markdown formatting, asterisks, or special characters for formatting.
''';
  }

  @override
  Future<List<String>> getItemsFromImage(File image) async {
    try {
      final imageBytes = await image.readAsBytes();

      final content = [
        Content.multi([
          TextPart(enhancedImagePrompt),
          InlineDataPart('image/png', imageBytes),
        ]),
      ];

      final res = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 30));

      final responseText = res.text;
      final cleanedResponse =
          responseText?.replaceAll(RegExp(r'```json|```'), '').trim();

      _log.d('AI Response: $cleanedResponse');

      final parsedRes = jsonDecode(cleanedResponse ?? '');
      final data = (parsedRes as List).map((e) => ItemData.fromMap(e)).toList();

      return data.map((e) => e.value).toList();
    } on TimeoutException {
      throw InternetFailure();
    } catch (e, s) {
      _log.e('Error analyzing image: $e', stackTrace: s);
      throw Failure(
        message:
            'Unable to analyze the image. Please try with a clearer image.',
        data: e,
      );
    }
  }

  @override
  Stream<String> streamStoryDetail(StoryParams storyParams) async* {
    try {
      final prompt = _buildStoryPrompt(storyParams);
      final content = [Content.text(prompt)];

      final res = await model.generateContent(content);
      yield res.text ?? 'No story generated.';
    } catch (e, s) {
      _log.e('Error generating story: $e', stackTrace: s);
      yield 'Something went wrong generating your story. Please try again.';
    }
  }

  @override
  Future<String> fetchStoryDetail(StoryParams storyParams) async {
    try {
      final prompt = _buildStoryPrompt(storyParams);
      final content = [Content.text(prompt)];

      final response = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 45));

      _log.d('Generated story length: ${response.text?.length} characters');
      return response.text ?? 'No story generated.';
    } on TimeoutException {
      throw InternetFailure();
    } catch (e, s) {
      _log.e('Error generating story: $e', stackTrace: s);
      throw Failure(
        message:
            'Unable to generate story. Please check your connection and try again.',
        data: e,
      );
    }
  }

  // New method for generating story titles
  Future<String> generateStoryTitle(List<String> items, String genre) async {
    try {
      final prompt = '''
Generate a catchy, creative title for a $genre story featuring these elements: ${items.join(', ')}.

The title should be:
- Engaging and memorable
- 2-6 words long
- Appropriate for the genre
- Not too generic
- Capture the essence of the story elements

Examples of good titles:
- "The Mysterious Path"
- "Castle in the Clouds"
- "Lost Treasure"
- "Moonlit Garden"

Return only the title, no quotes or additional text.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text?.trim() ?? 'Untitled Story';
    } catch (e) {
      _log.e('Error generating title: $e');
      return 'Untitled Story';
    }
  }

  // New method for story continuation
  Future<String> continueStory(String existingStory, String direction) async {
    try {
      final prompt = '''
Continue this story in a $direction direction:

$existingStory

Continue the narrative naturally, maintaining the same style, tone, and character voices.
Build upon the existing plot and add new developments.
Return only the continuation, not the full story.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text?.trim() ?? '';
    } catch (e) {
      _log.e('Error continuing story: $e');
      return '';
    }
  }
}
