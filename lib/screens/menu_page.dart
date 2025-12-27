import 'package:flutter/material.dart';
import 'swipe_page.dart';
import 'liked_page.dart';
import 'settings_page.dart';
import '../l10n/generated/app_localizations.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.6; // 60% of screen width
    final buttonHeight = size.height * 0.08; // 8% of screen height

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton(
              context,
              label: 'Login Page',
              icon: Icons.login,
              color: Colors.blue,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            SizedBox(height: size.height * 0.04),
            _menuButton(
              context,
              label: 'Swipe Page',
              icon: Icons.explore,
              color: Colors.orange,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () => Navigator.pushNamed(context, '/swipe'),
            ),
            SizedBox(height: size.height * 0.04),
            _menuButton(
              context,
              label: 'Liked Page',
              icon: Icons.favorite,
              color: Colors.pinkAccent,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () => Navigator.pushNamed(context, '/liked'),
            ),
            SizedBox(height: size.height * 0.04),
            _menuButton(
              context,
              label: 'Settings Page',
              icon: Icons.settings,
              color: Colors.grey,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            SizedBox(height: size.height * 0.04),
            _menuButton(
              context,
              label: 'Menu Page',
              icon: Icons.menu,
              color: Colors.green,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () => Navigator.pushNamed(context, '/menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: height * 0.5),
        label: Text(
          label,
          style: TextStyle(fontSize: height * 0.35, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.3),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
