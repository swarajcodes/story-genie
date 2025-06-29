import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_genie/core/app_colours.dart';


class StoryShareButton extends StatelessWidget {
  final String story;
  final String genre;
  final VoidCallback? onShare;

  const StoryShareButton({
    Key? key,
    required this.story,
    required this.genre,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _shareStory(context),
      icon: const Icon(Icons.share),
      tooltip: 'Share Story',
    );
  }

  void _shareStory(BuildContext context) {
    final shareText = '''
📚 Story Genie - $genre Story

$story

Generated with Story Genie by Swaraj Mohapatra ✨
''';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story copied to clipboard!'),
        backgroundColor: AppColors.bidPry500,
      ),
    );

    onShare?.call();
  }
}
