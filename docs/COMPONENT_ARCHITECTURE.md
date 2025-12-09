# 🏗️ Component & Feature Architecture

This document explains how components and features are built and managed in this Flutter project.

## 📁 Current Project Structure

```
lib/
├── models/          # Data models (shared across app)
├── providers/       # State management (shared logic)
├── services/        # Business logic & API calls (shared)
├── screens/         # Full page widgets
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## 🎯 Component Organization Strategy

### ✅ **Reusable Components** → `lib/widgets/`

**Purpose**: Components that can be used across multiple pages/screens.

**Current Examples:**
- `RestaurantCard` - Used in swipe page for displaying restaurant cards

**Characteristics:**
- Public classes (no underscore prefix)
- Accept data via constructor parameters
- Stateless or Stateful widgets
- No direct dependencies on specific pages
- Can be imported and reused anywhere

**Example:**
```dart
// lib/widgets/restaurant_card.dart
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({required this.restaurant});
  // ... implementation
}
```

### 📄 **Page-Specific Components** → Inside `lib/screens/`

**Purpose**: Components that are only used within a specific page.

**Current Examples:**
- `_RestaurantGridCard` in `liked_page.dart` (private widget, starts with `_`)
- `_menuButton` method in `menu_page.dart` (private helper method)
- `_swipeButton` method in `swipe_page.dart` (private helper method)

**Characteristics:**
- Private (starts with `_`)
- Defined within the page file where they're used
- Access to parent page's state/context
- Not meant to be reused elsewhere

**Example:**
```dart
// lib/screens/liked_page.dart
class LikedPage extends StatefulWidget {
  // ... page code
}

// Private widget only used in this page
class _RestaurantGridCard extends StatelessWidget {
  // ... implementation
}
```

## 🔄 Current Architecture Analysis

### ✅ **What's Working Well:**

1. **Separation of Concerns:**
   - `models/` - Data structures
   - `services/` - API/business logic
   - `providers/` - State management
   - `screens/` - Page-level UI
   - `widgets/` - Reusable components

2. **Reusable Components:**
   - `RestaurantCard` is properly extracted and reusable
   - Can be imported: `import '../widgets/restaurant_card.dart';`

3. **State Management:**
   - Providers are centralized and shared
   - Accessible via `Provider.of<T>(context)` or `context.watch<T>()`

### ⚠️ **Areas for Improvement:**

1. **Duplicate Logic:**
   - `RestaurantCard` (swipe page) and `_RestaurantGridCard` (liked page) have similar logic
   - Could be unified into a single reusable component with different variants

2. **Private Helpers:**
   - `_menuButton`, `_swipeButton` are methods, not widgets
   - Could be extracted to `widgets/` if needed elsewhere

3. **Feature-Specific Logic:**
   - `_showFloatingHeart()` animation logic is embedded in `swipe_page.dart`
   - Could be extracted to a separate utility or widget

## 📋 Component Creation Guidelines

### When to Create a Reusable Widget (`lib/widgets/`):

✅ **DO** create reusable widgets when:
- Component will be used in 2+ different pages
- Component represents a distinct UI element (button, card, form field)
- Component has its own state/logic that should be encapsulated
- Component can be tested independently

**Example:**
```dart
// lib/widgets/menu_button.dart
class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  const MenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
```

### When to Keep Components Page-Specific:

✅ **DO** keep components private when:
- Component is only used in one specific page
- Component needs direct access to parent page's state
- Component is tightly coupled to page-specific logic
- Extracting would create unnecessary complexity

**Example:**
```dart
// lib/screens/menu_page.dart
class MenuPage extends StatelessWidget {
  // Private helper - only used here
  Widget _menuButton(...) {
    // Implementation
  }
}
```

## 🎨 Feature Organization Patterns

### Pattern 1: **Page-Based** (Current Approach)
```
screens/
  ├── menu_page.dart          # Contains menu-specific UI
  ├── swipe_page.dart         # Contains swipe-specific UI + logic
  └── liked_page.dart         # Contains liked page UI + logic
```

**Pros:**
- Simple and straightforward
- Easy to find page-specific code
- Good for small to medium apps

**Cons:**
- Can lead to large files
- Logic mixed with UI
- Harder to test individual features

### Pattern 2: **Feature-Based** (Alternative Approach)
```
features/
  ├── restaurant_discovery/
  │   ├── screens/
  │   │   └── swipe_page.dart
  │   ├── widgets/
  │   │   └── restaurant_card.dart
  │   ├── providers/
  │   │   └── discovery_provider.dart
  │   └── services/
  │       └── restaurant_service.dart
  └── favorites/
      ├── screens/
      │   └── liked_page.dart
      └── widgets/
          └── restaurant_grid_card.dart
```

**Pros:**
- Better organization for large apps
- Features are self-contained
- Easier to test features independently
- Better code reusability

**Cons:**
- More complex structure
- Can be overkill for small apps

## 🔧 Current Component Usage Flow

### Example: Restaurant Card Usage

```
1. Data Source:
   HotPepperService.fetchShibuya()
   ↓
2. State Management:
   SwipePage State (_restaurants list)
   ↓
3. UI Rendering:
   CardSwiper widget
   ↓
4. Component:
   RestaurantCard (from widgets/)
   ↓
5. Display:
   Shows restaurant info
```

### Example: Liked Restaurants Flow

```
1. State Management:
   LikesProvider (shared state)
   ↓
2. UI Rendering:
   LikedPage (screen)
   ↓
3. Component:
   _RestaurantGridCard (private widget)
   ↓
4. Display:
   Grid of liked restaurants
```

## 📝 Recommendations for Future Development

### 1. **Extract Common Components**

Consider creating:
- `lib/widgets/menu_button.dart` - If menu buttons are needed elsewhere
- `lib/widgets/restaurant_grid_card.dart` - Extract from `_RestaurantGridCard`
- `lib/widgets/restaurant_detail_sheet.dart` - Extract detail modal

### 2. **Create Feature Folders** (if app grows)

If the app becomes larger, consider:
```
lib/
├── features/
│   ├── discovery/
│   ├── favorites/
│   └── settings/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
└── main.dart
```

### 3. **Separate Business Logic**

Consider extracting:
- Animation logic → `lib/utils/animations.dart` or `lib/widgets/animations/`
- Helper functions → `lib/utils/helpers.dart`
- Constants → `lib/constants/app_constants.dart`

## 🎯 Best Practices Summary

1. ✅ **Reusable components** → `lib/widgets/` (public, no `_`)
2. ✅ **Page-specific components** → Inside page files (private, with `_`)
3. ✅ **Business logic** → `lib/services/` (API calls, data processing)
4. ✅ **State management** → `lib/providers/` (shared app state)
5. ✅ **Data models** → `lib/models/` (shared data structures)
6. ✅ **Pages/Screens** → `lib/screens/` (full page widgets)

## 🔍 Finding Components

### To find reusable components:
```bash
# Look in widgets folder
ls lib/widgets/
```

### To find page-specific components:
```bash
# Search for private widgets (start with _)
grep -r "class _" lib/screens/
```

### To see component usage:
```bash
# Find where a component is imported
grep -r "RestaurantCard" lib/
```

---

**Last Updated**: [Update when architecture changes]

