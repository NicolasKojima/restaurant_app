import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/menu_page.dart';
import 'providers/locale_provider.dart';
import 'providers/likes_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Choose the file you want. For multiple flavors:
  // const envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env.production');
  // await dotenv.load(fileName: envFile);
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => LikesProvider()),
      ],
      child: const RestaurantSwipeApp(),
    ),
  );
}

class RestaurantSwipeApp extends StatelessWidget {
  const RestaurantSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Swipe',
      locale: context.watch<LocaleProvider>().locale,
      supportedLocales: const [Locale('en'), Locale('ja')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MenuPage(),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
    );
  }
}
