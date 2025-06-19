import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_addressing_app/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _mapTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CupertinoListSection.insetGrouped(
            header: const Text('APPEARANCE'),
            children: [
              CupertinoListTile(
                title: const Text('Dark Mode'),
                trailing: CupertinoSwitch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    themeNotifier.setTheme(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            children: const [
              CupertinoListTile(title: Text('Privacy Policy'), trailing: CupertinoListTileChevron()),
              CupertinoListTile(title: Text('Terms of Service'), trailing: CupertinoListTileChevron()),
              CupertinoListTile(title: Text('About'), trailing: CupertinoListTileChevron()),
            ],
          ),
        ],
      ),
    );
  }
}