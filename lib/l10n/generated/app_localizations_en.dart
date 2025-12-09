// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuTitle => 'Menu';

  @override
  String get searchRestaurants => 'Discover';

  @override
  String get likedRestaurants => 'Liked Restaurants';

  @override
  String get settings => 'Settings';

  @override
  String get discoverRestaurants => 'Discover Restaurants';

  @override
  String get noLikedRestaurants => 'You haven’t liked any restaurants yet.';

  @override
  String get genre => 'Genre';

  @override
  String get budget => 'Budget';

  @override
  String get close => 'Close';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get noRestaurantsFound => 'No restaurants found.';

  @override
  String get fetchError => 'Failed to load restaurants.';

  @override
  String get poweredBy => 'Powered by Hot Pepper Gourmet Web Service';

  @override
  String get like => 'Like';

  @override
  String get nope => 'Nope';

  @override
  String get details => 'Details';

  @override
  String get refresh => 'Refresh';
}
