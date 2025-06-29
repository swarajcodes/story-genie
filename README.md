# Story Genie 📚✨

A magical Flutter application that transforms your images into captivating stories using AI. Upload any image, select your preferred genre and story length, and watch as Story Genie weaves an enchanting narrative around the objects it detects in your photo.

## ✨ Features

- **🖼️ Image Upload**: Upload images from your gallery or camera
- **🤖 AI-Powered Analysis**: Automatically detects objects in your images using Google's Generative AI
- **📖 Story Generation**: Creates unique stories based on detected objects, genre, and length preferences
- **🎭 Multiple Genres**: Choose from various story genres (Adventure, Mystery, Fantasy, Romance, etc.)
- **📏 Customizable Length**: Select story length (Short, Medium, Long)
- **🌙 Dark/Light Theme**: Toggle between dark and light themes
- **📱 Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **🎨 Modern UI**: Beautiful, responsive design with smooth animations

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project (for AI services)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/story-genie.git
   cd story-genie
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add your Android/iOS apps to the project
   - Download and place the configuration files:
     - `google-services.json` in `android/app/` (for Android)
     - `GoogleService-Info.plist` in `ios/Runner/` (for iOS)

4. **Configure AI Services**

   - Set up Google Generative AI API key
   - Configure Firebase AI services

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

1. **Launch the app** and you'll see the main screen
2. **Upload an image** by tapping the upload area
3. **Select a genre** from the dropdown (Adventure, Mystery, Fantasy, etc.)
4. **Choose story length** (Short, Medium, Long)
5. **Tap "Generate Story"** and wait for the AI to analyze your image
6. **Enjoy your personalized story** based on the objects detected in your image!

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **AI Services**:
  - Google Generative AI (`google_generative_ai`)
  - Firebase AI (`firebase_ai`)
- **Image Handling**: `image_picker`
- **UI Components**:
  - `flutter_screenutil` for responsive design
  - `animated_text_kit` for text animations
  - `flutter_markdown` for rich text display
- **Logging**: `logger`
- **State Management**: Flutter's built-in StatefulWidget

## 📁 Project Structure

```
lib/
├── core/                 # App constants, colors, themes, text styles
├── models/              # Data models (Failure, ItemData, StoryParams)
├── screens/             # Main app screens
│   ├── image_selector_view.dart
│   └── story_view.dart
├── services/            # Business logic and external services
│   ├── ai_service/      # AI integration
│   └── media_service/   # Image handling
├── widgets/             # Reusable UI components
│   ├── shared/          # Common widgets
│   └── ...              # Feature-specific widgets
└── main.dart           # App entry point
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory with your API keys:

```
GOOGLE_AI_API_KEY=your_google_ai_api_key
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### Firebase Setup

1. Enable Firebase AI services in your Firebase console
2. Configure authentication and security rules
3. Set up proper API quotas and billing

## 🎨 Customization

### Themes

The app supports both light and dark themes. You can customize colors in `lib/core/app_colours.dart` and themes in `lib/core/app_theme.dart`.

### Genres and Story Lengths

Modify the available options in `lib/core/app_constants.dart`:

```dart
static const List<String> genres = ['Adventure', 'Mystery', 'Fantasy', ...];
static const List<String> storyLength = ['Short', 'Medium', 'Long'];
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google Generative AI for powerful image analysis
- Firebase for backend services
- Flutter team for the amazing framework
- All contributors and supporters

## 📞 Support

If you encounter any issues or have questions:

- Open an issue on GitHub
- Check the [Flutter documentation](https://docs.flutter.dev/)
- Review Firebase setup guides

---

**Made with ❤️ and Flutter**

_Transform your images into stories with Story Genie!_
