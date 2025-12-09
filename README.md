# 🍽️ Restaurant Search App

A modern Flutter application for discovering restaurants in Tokyo using a Tinder-like swipe interface. Built with Flutter and integrated with the Hot Pepper Gourmet API. Currently being planned and released for Tokyo-wide coverage.

## ✨ Features

- **Swipe Interface**: Discover restaurants with an intuitive card-swipe interface (swipe right to like, left to pass)
- **Restaurant Discovery**: Browse restaurants across Tokyo using the Hot Pepper Gourmet API
- **Liked Restaurants**: Save and view your favorite restaurants in a beautiful grid layout
- **Genre Filtering**: Filter liked restaurants by cuisine genre
- **Bilingual Support**: Full support for English and Japanese languages
- **Responsive Design**: Works seamlessly on web, iOS, Android, macOS, Linux, and Windows
- **Modern UI**: Built with Material Design 3 and smooth animations

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0.6+
- **State Management**: Provider
- **API**: Hot Pepper Gourmet Web Service
- **Localization**: Flutter Intl with ARB files
- **HTTP Client**: http package
- **Environment Variables**: flutter_dotenv
- **Card Swiper**: flutter_card_swiper

## 📋 Prerequisites

- Flutter SDK (>=3.0.6 <4.0.0)
- Dart SDK
- Hot Pepper Gourmet API Key ([Get one here](https://webservice.recruit.co.jp/))
- For web deployment: Cloudflare Workers proxy (for CORS handling)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/NicolasKojima/restaurant_app.git
cd restaurant_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create a `.env` file in the root directory:

```bash
cp example.env .env
```

Edit `.env` and add your Hot Pepper Gourmet API key:

```
HOTPEPPER_API_KEY=your_api_key_here
```

**Note**: For web builds, the app uses a Cloudflare Workers proxy to handle CORS. The proxy URL is configured in `lib/services/hotpepper_service.dart`. For mobile builds, the API key is used directly.

### 4. Generate Localization Files

```bash
flutter gen-l10n
```

### 5. Run the App

#### Web (Chrome)
```bash
flutter run -d chrome
```

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

#### macOS
```bash
flutter run -d macos
```

## 📱 App Structure

```
lib/
├── l10n/                    # Localization files (ARB + generated)
├── models/                  # Data models
│   └── restaurant.dart      # Restaurant model
├── providers/               # State management (Provider)
│   ├── likes_provider.dart  # Manages liked restaurants
│   └── locale_provider.dart # Manages app locale
├── screens/                 # App screens
│   ├── menu_page.dart       # Main menu
│   ├── swipe_page.dart      # Restaurant discovery/swipe
│   ├── liked_page.dart      # Liked restaurants grid
│   └── settings_page.dart   # Settings (language selection)
├── services/                # API services
│   └── hotpepper_service.dart # Hot Pepper API integration
├── widgets/                 # Reusable widgets
│   └── restaurant_card.dart # Restaurant card component
└── main.dart                # App entry point
```

## 📚 Documentation

Comprehensive project documentation is available in the [`docs/`](./docs/) directory:

- **[PROGRESS.md](./docs/PROGRESS.md)** - Progress tracking and milestones

See the [Documentation README](./docs/README.md) for more information on the documentation structure.

## 🌐 Localization

The app supports English and Japanese. Localization files are located in `lib/l10n/`:

- `app_en.arb` - English translations
- `app_ja.arb` - Japanese translations

To add new translations or modify existing ones, edit the ARB files and run:

```bash
flutter gen-l10n
```

## 🔧 Configuration

### Hot Pepper API Proxy (Web)

For web builds, the app uses a Cloudflare Workers proxy to handle CORS issues. The proxy URL is configured in `lib/services/hotpepper_service.dart`:

```dart
static const _proxyBase = 'https://hotpepper-proxy.restaurant-search.workers.dev/';
```

If you need to set up your own proxy, you'll need to:
1. Create a Cloudflare Worker
2. Update the proxy URL in the service file
3. Ensure the proxy handles CORS headers properly

### Area Configuration

The app is designed to support restaurants across Tokyo. Currently, the implementation includes support for various Tokyo areas (starting with Shibuya as an example area code: Y030). The app is being expanded to cover Tokyo-wide areas as part of the planned release. To modify the search area, update the area code parameters in `lib/services/hotpepper_service.dart`.

## 📦 Building for Production

### Web

```bash
flutter build web
```

The output will be in `build/web/`. Deploy this directory to your hosting service.

### iOS

```bash
flutter build ios
```

### Android

```bash
flutter build apk
# or
flutter build appbundle
```

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📝 Project Status

This project is currently being planned and released for Tokyo-wide restaurant discovery. The app is actively under development with core features stable and working. We're expanding coverage to include more areas across Tokyo as part of the release plan.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Hot Pepper Gourmet Web Service](https://webservice.recruit.co.jp/) for providing the restaurant data API
- Flutter team for the amazing framework
- All contributors and users of this project

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Note**: This app uses the Hot Pepper Gourmet API. Please ensure you comply with their terms of service when using this application.
