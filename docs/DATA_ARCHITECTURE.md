# 💾 Data Architecture

This document explains how data is stored, retrieved, and managed in the Restaurant Search App.

## 🎯 Overview

**Important**: This application **does NOT use a traditional database**. Instead, it uses:

1. **External API** - Restaurant data is fetched from Hot Pepper Gourmet API
2. **In-Memory Storage** - Liked restaurants are stored in memory only (lost on app restart)
3. **No Local Persistence** - Currently, no data is saved to device storage

## 📊 Data Flow Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User Action                          │
│              (Opens Swipe Page)                         │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SwipePage.initState()                      │
│         Creates HotPepperService instance               │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│         HotPepperService.fetchShibuya()                 │
│                                                          │
│  • Makes HTTP GET request                               │
│  • Web: Uses Cloudflare Proxy                          │
│  • Mobile: Direct API call                             │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│         Hot Pepper Gourmet API                          │
│    (External - webservice.recruit.co.jp)                │
│                                                          │
│  Returns JSON response with restaurant data             │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│      HotPepperService.parseResponse()                   │
│                                                          │
│  • Parses JSON                                         │
│  • Maps to Restaurant model objects                     │
│  • Returns List<Restaurant>                            │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│         SwipePage State (_restaurants)                  │
│                                                          │
│  • Stores List<Restaurant> in memory                   │
│  • Displays in CardSwiper widget                        │
└─────────────────────────────────────────────────────────┘
```

## 🔄 Data Retrieval (Read Operations)

### Restaurant Discovery Data

**Source**: Hot Pepper Gourmet API (External)

**How it works:**

1. **Service Layer** (`lib/services/hotpepper_service.dart`):
   ```dart
   class HotPepperService {
     Future<List<Restaurant>> fetchShibuya({int count = 30}) async {
       // Makes HTTP GET request
       // Parses JSON response
       // Returns List<Restaurant>
     }
   }
   ```

2. **API Endpoints**:
   - **Web**: `https://hotpepper-proxy.restaurant-search.workers.dev/`
   - **Mobile**: `https://webservice.recruit.co.jp/hotpepper/gourmet/v1/`

3. **Request Flow**:
   ```
   SwipePage.initState()
     ↓
   HotPepperService.fetchShibuya(count: 40)
     ↓
   HTTP GET Request (with area code Y030, count, format=json)
     ↓
   Parse JSON Response
     ↓
   Map to Restaurant objects
     ↓
   Store in SwipePage._restaurants (in-memory List)
   ```

4. **Data Structure**:
   ```dart
   class Restaurant {
     final String id;
     final Map<String, String> name;      // {'ja': '...', 'en': '...'}
     final Map<String, String> description;
     final String? imageUrl;
     final String? genre;
     final String? budget;
   }
   ```

### Liked Restaurants Data

**Source**: In-Memory List (No persistence)

**How it works:**

1. **State Management** (`lib/providers/likes_provider.dart`):
   ```dart
   class LikesProvider extends ChangeNotifier {
     final List<Restaurant> _liked = [];  // In-memory only!
     
     void like(Restaurant r) {
       _liked.add(r);
       notifyListeners();
     }
   }
   ```

2. **Storage Location**: 
   - Stored in `LikesProvider._liked` (private List)
   - Lives in memory during app session
   - **Lost when app closes**

3. **Access Pattern**:
   ```dart
   // In any widget
   final likes = context.watch<LikesProvider>();
   final likedRestaurants = likes.liked;  // Read-only list
   ```

## ✍️ Data Writing (Write Operations)

### Adding Liked Restaurants

**Operation**: `LikesProvider.like()`

**How it works:**

```dart
// When user swipes right
likes.like(restaurant);

// Internally:
void like(Restaurant r) {
  if (!isLiked(r)) {
    _liked.add(r);           // Add to in-memory list
    notifyListeners();        // Notify UI to update
  }
}
```

**Storage**: 
- ✅ Added to `_liked` list in memory
- ❌ **NOT saved to disk**
- ❌ **NOT persisted to database**
- ❌ **Lost on app restart**

### Removing Liked Restaurants

**Operation**: `LikesProvider.unlike()`

```dart
likes.unlike(restaurant);

// Internally:
void unlike(Restaurant r) {
  _liked.removeWhere((x) => x.id == r.id);
  notifyListeners();
}
```

### Clearing All Likes

**Operation**: `LikesProvider.clear()`

```dart
likes.clear();

// Internally:
void clear() {
  _liked.clear();
  notifyListeners();
}
```

## 🗄️ Current Storage Architecture

### ❌ **No Database**

The application does **NOT** use:
- ❌ SQLite (sqflite package)
- ❌ Hive (NoSQL database)
- ❌ SharedPreferences (key-value storage)
- ❌ Firebase/Firestore
- ❌ Any other database solution

### ✅ **Current Storage Methods**

1. **In-Memory State** (Provider):
   - `LikesProvider._liked` - List of liked restaurants
   - Lives only during app session
   - Cleared when app closes

2. **External API**:
   - Restaurant data fetched on-demand
   - Not cached locally
   - Fresh data on each app launch

## 📍 Where Data Lives

### Restaurant Discovery Data

```
┌─────────────────────────────────────┐
│   Hot Pepper Gourmet API            │
│   (External Server)                 │
│                                     │
│   • Fetched on SwipePage load      │
│   • Stored in SwipePage._restaurants│
│   • In-memory only                 │
│   • Not persisted                  │
└─────────────────────────────────────┘
```

### Liked Restaurants Data

```
┌─────────────────────────────────────┐
│   LikesProvider                     │
│   (In-Memory State)                │
│                                     │
│   private List<Restaurant> _liked  │
│                                     │
│   • Stored in RAM                  │
│   • Lost on app restart            │
│   • Not saved to disk              │
└─────────────────────────────────────┘
```

## 🔍 Data Lifecycle

### Restaurant Discovery Data

```
App Launch
    ↓
User Opens Swipe Page
    ↓
HotPepperService.fetchShibuya()
    ↓
API Request → External Server
    ↓
Response → Parse JSON
    ↓
Store in SwipePage._restaurants (memory)
    ↓
Display in UI
    ↓
[Data exists until page is disposed]
    ↓
App Closes → Data Lost
```

### Liked Restaurants Data

```
User Swipes Right
    ↓
LikesProvider.like(restaurant)
    ↓
Add to _liked list (memory)
    ↓
Notify listeners → UI updates
    ↓
[Data persists during app session]
    ↓
App Closes → Data Lost ❌
```

## ⚠️ Current Limitations

### 1. **No Persistence**
- Liked restaurants are lost when app closes
- No way to recover liked restaurants after restart
- No offline access to liked restaurants

### 2. **No Caching**
- Restaurant data is fetched fresh every time
- No local cache of API responses
- Requires internet connection for every load

### 3. **No Data Validation**
- No validation of API responses
- No error recovery mechanism
- No retry logic for failed requests

## 🚀 Future Improvements (Recommended)

### Option 1: Add Local Persistence

**Use SharedPreferences** (Simple key-value storage):
```dart
// Save liked restaurants
final prefs = await SharedPreferences.getInstance();
final json = jsonEncode(likedRestaurants.map((r) => r.toJson()).toList());
await prefs.setString('liked_restaurants', json);

// Load on app start
final json = prefs.getString('liked_restaurants');
if (json != null) {
  final list = jsonDecode(json).map((r) => Restaurant.fromJson(r)).toList();
  _liked.addAll(list);
}
```

**Use Hive** (NoSQL database):
```dart
// More robust, better for complex data
// Supports relationships, queries, etc.
```

### Option 2: Add Caching

**Cache API Responses**:
```dart
// Store restaurant data locally
// Check cache before making API call
// Update cache periodically
```

### Option 3: Add Cloud Sync

**Firebase/Firestore**:
```dart
// Sync liked restaurants across devices
// User accounts
// Cloud backup
```

## 📝 Summary

| Data Type | Storage Location | Persistence | Lifecycle |
|-----------|-----------------|-------------|-----------|
| Restaurant Discovery | External API + In-Memory | ❌ No | Fetched on-demand, lost on page dispose |
| Liked Restaurants | In-Memory (LikesProvider) | ❌ No | Lost on app restart |
| App Settings | In-Memory (LocaleProvider) | ❌ No | Lost on app restart |

## 🔧 Technical Details

### API Request Example

```dart
// Web (via proxy)
GET https://hotpepper-proxy.restaurant-search.workers.dev/
  ?format=json
  &middle_area=Y030
  &count=40
  &type=lite

// Mobile (direct)
GET https://webservice.recruit.co.jp/hotpepper/gourmet/v1/
  ?format=json
  &middle_area=Y030
  &count=40
  &type=lite
  &key=YOUR_API_KEY
```

### Data Model

```dart
Restaurant {
  id: String                    // Unique identifier
  name: Map<String, String>     // {'ja': '...', 'en': '...'}
  description: Map<String, String>
  imageUrl: String?              // Optional image URL
  genre: String?                 // Optional cuisine type
  budget: String?                 // Optional price range
}
```

---

**Last Updated**: [Update when data architecture changes]

