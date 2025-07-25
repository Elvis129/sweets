# Sweet Billions

A candy-themed slot machine game built with Flutter and Flame.

## Features

- 5x6 grid slot machine with candy symbols
- Win by matching 7+ of the same symbol
- Multiple backgrounds to unlock
- Sound effects and background music
- Credits system with persistent storage
- Portrait mode only
- Android support

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app in debug mode

### Building for Release

```bash
flutter build apk --release
```

## Game Rules

- Each spin costs 10 credits
- Match 7 or more of the same symbol to win
- Wins are multiplied based on the number of matching symbols:
  - 7 symbols: Base win
  - 8-9 symbols: 1.2x multiplier
  - 10 symbols: 1.4x multiplier
  - 11+ symbols: 1.5x multiplier

## Assets

The game includes various candy-themed assets:
- Symbol sprites (candy, fruits, sweets)
- Background images (different candy worlds)
- Sound effects and background music

## Project Structure

```
lib/
  ├── core/
  │   ├── providers/      # State management
  │   ├── services/       # Game services
  │   └── theme/          # UI theme
  ├── features/
  │   ├── game/          # Main game logic
  │   ├── home/          # Home screen
  │   ├── loading/       # Loading screen
  │   ├── settings/      # Settings screen
  │   └── shop/          # Shop screen
  └── main.dart          # App entry point
```

## Dependencies

- flame: ^1.14.0 - 2D game engine
- provider: ^6.1.1 - State management
- shared_preferences: ^2.2.2 - Local storage
- audioplayers: ^5.2.1 - Audio playback
- google_fonts: ^6.1.0 - Custom fonts
- flutter_svg: ^2.0.9 - SVG support

## License

This project is proprietary and confidential. All rights reserved. 