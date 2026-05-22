import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({StorageService? storage}) : _storage = storage ?? StorageService();

  final StorageService _storage;
  bool _isDark = false;

  bool get isDark => _isDark;

  Future<void> load() async {
    _isDark = await _storage.isDarkMode();
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    await _storage.setDarkMode(_isDark);
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    await _storage.setDarkMode(value);
    notifyListeners();
  }
}
