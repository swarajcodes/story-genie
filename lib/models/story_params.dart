class StoryParams {
  final List<String> items;
  final String genre;
  final String length;

  const StoryParams({
    required this.items,
    required this.genre,
    required this.length,
  });

  String get parsedLength {
    switch (length.toLowerCase()) {
      case 'short':
        return 'at least 1 paragraph (100-150 words)';
      case 'medium':
        return 'at least 2 paragraphs (200-300 words)';
      case 'long':
        return 'at least 3 paragraphs (400-500 words)';
      default:
        return 'at least 1 paragraph (100-150 words)';
    }
  }
}
