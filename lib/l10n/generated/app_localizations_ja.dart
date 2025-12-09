// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get menuTitle => 'メニュー';

  @override
  String get searchRestaurants => 'レストランを探す';

  @override
  String get likedRestaurants => 'お気に入りのレストラン';

  @override
  String get settings => '設定';

  @override
  String get discoverRestaurants => 'レストランを見る';

  @override
  String get noLikedRestaurants => 'お気に入りのレストランがまだありません。';

  @override
  String get genre => 'ジャンル';

  @override
  String get budget => '予算';

  @override
  String get close => '閉じる';

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get clearFilter => 'フィルターをクリア';

  @override
  String get noRestaurantsFound => 'レストランが見つかりません。';

  @override
  String get fetchError => 'レストランの読み込みに失敗しました。';

  @override
  String get poweredBy => 'ホットペッパーグルメ Webサービス';

  @override
  String get like => 'いいね';

  @override
  String get nope => 'スキップ';

  @override
  String get details => '詳細';

  @override
  String get refresh => '更新';
}
