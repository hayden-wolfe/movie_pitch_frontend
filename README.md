# 🎬 Movie Pitch Generator

A Flutter app that generates creative movie pitches using AI! Spin the wheels to randomly select characters, creatives, locations, and genres, then let an AI generate a unique movie pitch based on your selections.

## Features

- **Interactive Spinning Wheels** - "Price is Right" style wheels for each category
- **Dynamic Wheel Management** - Add or remove wheels per category (1-3 characters, 1-2 for others)
- **Lock & Edit Modes** - Lock wheels on specific values or enter custom text
- **AI-Powered Pitches** - Backend integration generates creative movie pitches from popular LLMs
- **Beautiful Dark Theme** - Modern UI with gradients, animations, and visual polish

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) 3.7.0 or higher
- A running instance of the *Movie Pitch Generator Backend* (will be added soon)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/movie_pitch_generator.git
   cd movie_pitch_generator
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure the backend URL (optional):
   
   Edit `lib/services/pitch_api_service.dart` and update `baseUrl`:
   ```dart
   static const String baseUrl = 'http://your-backend-url:8000';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── data/
│   └── wheel_data.dart       # Predefined wheel items and categories
├── models/
│   ├── pitch_result.dart     # API response model
│   └── wheel_category.dart   # Category configuration model
├── screens/
│   ├── home_screen.dart      # Main game screen
│   └── pitch_result_screen.dart  # Displays generated pitch
├── services/
│   └── pitch_api_service.dart    # Backend API integration
├── widgets/
│   ├── spin_button.dart      # Animated spin button
│   ├── spinning_wheel.dart   # Core wheel widget with lock/edit
│   └── wheel_category_section.dart  # Category section UI
└── main.dart                 # App entry point
```

## Backend API

The app expects a backend running at `http://127.0.0.1:8000` (configurable) with the following endpoint:

**POST** `/generate-pitch`

Request:
```json
{
  "characters": ["Character 1", "Character 2"],
  "locations": ["Location 1"],
  "genres": ["Genre 1"],
  "creatives": ["Director/Writer 1"]
}
```

Response:
```json
{
  "title": "Movie Title",
  "tagline": "A catchy tagline",
  "pitch": "The full movie pitch description..."
}
```

## Customization

### Adding Wheel Items

Edit `lib/data/wheel_data.dart` to modify the predefined items for each category:

```dart
const List<String> characterItems = [
  'Your Character 1',
  'Your Character 2',
  // ...
];
```

### Category Configuration

Adjust min/max wheel counts in `wheelCategories`:

```dart
WheelCategory(
  id: 'characters',
  displayName: 'Characters',
  items: characterItems,
  minWheels: 1,
  maxWheels: 5,  // Allow up to 5 character wheels
  defaultWheelCount: 2,
),
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Uses [Google Fonts](https://pub.dev/packages/google_fonts) for typography
