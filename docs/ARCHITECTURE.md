# 🏛️ System Architecture

This document describes the architecture and design decisions of the Restaurant Search App.

## 📐 High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Flutter App                         │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Screens    │  │   Widgets    │  │  Providers   │  │
│  │              │  │              │  │              │  │
│  │ - MenuPage   │  │ - Restaurant │  │ - Likes      │  │
│  │ - SwipePage  │  │   Card       │  │ - Locale     │  │
│  │ - LikedPage  │  │              │  │              │  │
│  │ - Settings   │  │              │  │              │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                  │                  │          │
│         └──────────────────┼──────────────────┘          │
│                            │                             │
│                   ┌─────────▼─────────┐                  │
│                   │     Services      │                  │
│                   │                   │                  │
│                   │ - HotPepperService│                  │
│                   └─────────┬─────────┘                  │
│                             │                             │
└─────────────────────────────┼─────────────────────────────┘
                              │
                    ┌──────────▼──────────┐
                    │   External APIs     │
                    │                     │
                    │ - Hot Pepper API    │
                    │ - Cloudflare Proxy  │
                    │   (Web only)        │
                    └─────────────────────┘
```

## 🗂️ Directory Structure

```
lib/
├── l10n/              # Localization (ARB + generated)
├── models/           # Data models
│   └── restaurant.dart
├── providers/        # State management
│   ├── likes_provider.dart
│   └── locale_provider.dart
├── screens/          # UI screens
│   ├── menu_page.dart
│   ├── swipe_page.dart
│   ├── liked_page.dart
│   └── settings_page.dart
├── services/         # Business logic & API
│   └── hotpepper_service.dart
├── widgets/          # Reusable UI components
│   └── restaurant_card.dart
└── main.dart         # App entry point
```

## 🔄 Data Flow

### Restaurant Discovery Flow

```
User Action (Swipe)
    ↓
SwipePage (UI)
    ↓
CardSwiper (Gesture Detection)
    ↓
onSwipe Callback
    ↓
LikesProvider (State Update)
    ↓
UI Re-render
```

### API Data Flow

```
SwipePage.initState()
    ↓
HotPepperService.fetchShibuya()
    ↓
Platform Check (Web vs Mobile)
    ↓
API Request (Direct or Proxy)
    ↓
Parse JSON Response
    ↓
Create Restaurant Models
    ↓
Update State
    ↓
Render Cards
```

## 🎨 UI Architecture

### Design System
- **Material Design 3**: Modern Material Design implementation
- **Color Scheme**: Orange-based theme (`colorSchemeSeed: Colors.orange`)
- **Responsive**: Adapts to different screen sizes
- **Localized**: Full i18n support

### Component Hierarchy

```
MaterialApp
└── MenuPage (Home)
    ├── SwipePage
    │   ├── CardSwiper
    │   │   └── RestaurantCard (multiple)
    │   └── Bottom Navigation (Like/Nope buttons)
    ├── LikedPage
    │   ├── Genre Filter Chips
    │   └── GridView
    │       └── RestaurantGridCard (multiple)
    └── SettingsPage
        └── Language Selection
```

## 🔌 Service Layer

### HotPepperService

**Responsibilities:**
- API communication
- Platform-aware routing (web proxy vs direct)
- Data transformation (JSON → Restaurant models)
- Error handling

**Key Methods:**
- `fetchShibuya({int count})`: Fetches restaurants from Shibuya area

**Platform Detection:**
- Uses `kIsWeb` to determine platform
- Web: Routes through Cloudflare proxy
- Mobile: Direct API calls with API key

## 📦 State Management

### Provider Pattern

**LikesProvider:**
- Manages liked restaurants list
- Provides `like()`, `unlike()`, `clear()` methods
- Notifies listeners on changes

**LocaleProvider:**
- Manages app locale (en/ja)
- Provides `setLocale()` method
- Persists across app restarts (if implemented)

## 🌐 Localization Architecture

```
ARB Files (app_en.arb, app_ja.arb)
    ↓
flutter gen-l10n
    ↓
Generated Files (app_localizations.dart)
    ↓
AppLocalizations.of(context)
    ↓
UI Components
```

## 🔐 Security Architecture

### API Key Management
- **Web**: API key stored server-side in Cloudflare Worker
- **Mobile**: API key in `.env` file (not committed)
- **Runtime**: API key loaded via `flutter_dotenv`

### Data Privacy
- No user data collected
- Liked restaurants stored only in memory
- No tracking or analytics (currently)

## 🚀 Performance Considerations

### Image Loading
- Network images loaded on-demand
- Error handling for failed image loads
- Web: Images proxied through Cloudflare Worker

### State Updates
- Provider pattern minimizes unnecessary rebuilds
- List operations use efficient data structures

### API Calls
- Single API call on page load
- No pagination currently (loads all at once)
- Consider implementing pagination for large datasets

## 🔮 Future Architecture Considerations

### Planned Improvements
- Persistent storage layer (Hive/SharedPreferences)
- Caching layer for API responses
- Offline support
- Background sync
- User authentication (if needed)

### Scalability
- Consider implementing repository pattern
- Add dependency injection (get_it)
- Separate business logic from UI
- Add proper error handling layer

---

**Last Updated**: [Update this date when architecture changes]



