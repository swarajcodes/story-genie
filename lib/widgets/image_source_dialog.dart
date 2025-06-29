import 'package:flutter/material.dart';

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({super.key});

  Future<T?> show<T>(BuildContext context) =>
      showDialog(context: context, builder: (context) => this);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      title: Text(
        'Select Image Source',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              onTap: () => Navigator.pop(context, false),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Divider(height: 1, color: colorScheme.outline.withOpacity(0.3)),
            const SizedBox(height: 4),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              onTap: () => Navigator.pop(context, true),
              leading: CircleAvatar(
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: colorScheme.secondary,
                  size: 28,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
