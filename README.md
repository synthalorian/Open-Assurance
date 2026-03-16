# Open Assurance

<p align="center">
  <img src="assets/images/app_icon.png" alt="Open Assurance Logo" width="120">
</p>

<h3 align="center">Words of hope when you need them most</h3>

<p align="center">
  A free, open-source mobile app providing words of affirmation and mental wellness support.
</p>

---

## ✨ Features

### Core Features
- 📜 **Affirmation Library** - 100+ curated affirmations across 10 categories
- 🔔 **Daily Notifications** - Gentle morning/evening reminders
- ⭐ **Favorites** - Save affirmations that resonate with you
- 📤 **Share** - Share affirmations with friends and loved ones
- ✍️ **Custom Affirmations** - Write and save your own
- 🤖 **Generator** - Generate personalized affirmations
- 📊 **Mood Tracking** - Log your mood and see patterns over time
- 🏠 **Home Widgets** - Daily affirmation on your home screen

### Bonus Features
- 🧘 **Breathing Exercises** - Guided breathing patterns (4-7-8, Box Breathing, etc.)
- 🆘 **Crisis Resources** - Real hotlines and support resources
- 🎵 **Ambient Sounds** - Rain, waves, forest, and more
- 🌙 **Dark Mode** - Beautiful synthwave-inspired theme

## 📱 Screenshots

*Coming soon*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/open-assurance/open-assurance.git
cd open-assurance

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🏗️ Project Structure

```
lib/
├── core/               # Shared utilities and widgets
│   ├── constants/      # Colors, strings, resources
│   ├── theme/          # App theme configuration
│   ├── utils/          # Services (audio, notifications, sharing)
│   └── widgets/        # Shared widgets
├── features/
│   ├── affirmations/   # Affirmation feature
│   ├── favorites/      # Favorites management
│   ├── mood_tracking/  # Mood logging and history
│   ├── breathing/      # Breathing exercises
│   ├── crisis/         # Crisis resources
│   ├── ambient/        # Ambient sounds
│   ├── generator/      # Custom affirmation generator
│   └── more/           # Settings and about
├── app.dart            # App configuration
└── main.dart           # Entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 💜 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Inspired by the need for accessible mental health resources
- Made with love for those who need words of hope

---

**You matter. Your feelings are valid. There is hope.** 💜

If you're in crisis, please reach out:
- **US**: 988 Suicide & Crisis Lifeline
- **Text**: HOME to 741741
- **International**: [befrienders.org](https://www.befrienders.org)
