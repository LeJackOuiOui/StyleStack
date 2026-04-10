import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // Tema por defecto: Antracita (oscuro)
  AppThemeOption _current = AppThemes.all.firstWhere(
    (t) => t.id == 'dark_anthracite',
  );

  AppThemeOption get current => _current;
  ThemeData get themeData => _current.data;

  ThemeProvider() {
    _loadFromDisk();
  }

  void setTheme(String id) {
    final found = AppThemes.all.where((t) => t.id == id);
    if (found.isEmpty) return;
    _current = found.first;
    _saveToDisk(id);
    notifyListeners();
  }

  Future<void> _saveToDisk(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', id);
  }

  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('selected_theme');
    if (savedId != null) {
      final found = AppThemes.all.where((t) => t.id == savedId);
      if (found.isNotEmpty) {
        _current = found.first;
        notifyListeners();
      }
    }
  }
}