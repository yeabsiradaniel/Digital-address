import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  get themeMode => _themeMode;

  void setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
  }
}