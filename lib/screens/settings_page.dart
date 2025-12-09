import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/generated/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: Column(
        children: [
          ListTile(
            title: Text(t.english),
            leading: Radio<Locale>(
              value: const Locale('en'),
              groupValue: provider.locale,
              onChanged: (Locale? locale) {
                provider.setLocale(locale!);
              },
            ),
          ),
          ListTile(
            title: Text(t.japanese),
            leading: Radio<Locale>(
              value: const Locale('ja'),
              groupValue: provider.locale,
              onChanged: (Locale? locale) {
                provider.setLocale(locale!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
