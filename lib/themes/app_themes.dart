import 'package:flutter/material.dart';

// ─── MODELO DE TEMA ──────────────────────────────────────────────────────────
class AppThemeOption {
  final String id;
  final String name;
  final String description;
  final ThemeData data;
  final bool isDark;

  const AppThemeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.data,
    required this.isDark,
  });
}

// ─── LOS 10 TEMAS ────────────────────────────────────────────────────────────
class AppThemes {
  AppThemes._();

  static final List<AppThemeOption> all = [
    ..._lightThemes,
    ..._darkThemes,
  ];

  // ── TEMAS CLAROS ────────────────────────────────────────────────────────────

  static final List<AppThemeOption> _lightThemes = [
    // 1. Blanco puro — contraste máximo
    AppThemeOption(
      id: 'light_pure',
      name: 'Blanco puro',
      description: 'Contraste máximo, fondo blanco',
      isDark: false,
      data: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 2. Lavanda suave — contraste medio-alto
    AppThemeOption(
      id: 'light_lavender',
      name: 'Lavanda',
      description: 'Tono lavanda, contraste medio-alto',
      isDark: false,
      data: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B5EA7),
          brightness: Brightness.light,
          surface: const Color(0xFFF3EFFF),
          onSurface: const Color(0xFF1A1040),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3EFFF),
        cardColor: const Color(0xFFE8E0FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEDE8FF),
          foregroundColor: Color(0xFF1A1040),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 3. Crema — contraste suave, cálido
    AppThemeOption(
      id: 'light_cream',
      name: 'Crema',
      description: 'Fondo cálido, contraste suave',
      isDark: false,
      data: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB5651D),
          brightness: Brightness.light,
          surface: const Color(0xFFFFF8EF),
          onSurface: const Color(0xFF3E2000),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8EF),
        cardColor: const Color(0xFFF5E6C8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF0D6),
          foregroundColor: Color(0xFF3E2000),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 4. Menta — contraste medio, fresco
    AppThemeOption(
      id: 'light_mint',
      name: 'Menta',
      description: 'Tono verde menta, contraste medio',
      isDark: false,
      data: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D5E),
          brightness: Brightness.light,
          surface: const Color(0xFFEFF8F4),
          onSurface: const Color(0xFF0A2E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFFEFF8F4),
        cardColor: const Color(0xFFD4EFDF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE0F2E9),
          foregroundColor: Color(0xFF0A2E1E),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 5. Gris perla — contraste bajo, minimalista
    AppThemeOption(
      id: 'light_pearl',
      name: 'Gris perla',
      description: 'Minimalista, contraste bajo',
      isDark: false,
      data: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF607D8B),
          brightness: Brightness.light,
          surface: const Color(0xFFF0F2F4),
          onSurface: const Color(0xFF263238),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2F4),
        cardColor: const Color(0xFFDFE4E8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8ECEF),
          foregroundColor: Color(0xFF263238),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),
  ];

  // ── TEMAS OSCUROS ────────────────────────────────────────────────────────────

  static final List<AppThemeOption> _darkThemes = [
    // 6. Negro absoluto — AMOLED, contraste máximo
    AppThemeOption(
      id: 'dark_amoled',
      name: 'AMOLED',
      description: 'Negro puro, contraste máximo',
      isDark: true,
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 7. Antracita — contraste alto, gris muy oscuro
    AppThemeOption(
      id: 'dark_anthracite',
      name: 'Antracita',
      description: 'Gris carbón, contraste alto',
      isDark: true,
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1A1A),
          onSurface: const Color(0xFFEEEEEE),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF252525),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFFEEEEEE),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 8. Medianoche — contraste medio, azul muy oscuro
    AppThemeOption(
      id: 'dark_midnight',
      name: 'Medianoche',
      description: 'Azul profundo, contraste medio',
      isDark: true,
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D5AFE),
          brightness: Brightness.dark,
          surface: const Color(0xFF0D1B2A),
          onSurface: const Color(0xFFCDD9E5),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        cardColor: const Color(0xFF152232),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          foregroundColor: Color(0xFFCDD9E5),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 9. Bosque nocturno — contraste medio-bajo, verde oscuro
    AppThemeOption(
      id: 'dark_forest',
      name: 'Bosque',
      description: 'Verde oscuro, contraste medio-bajo',
      isDark: true,
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F1F10),
          onSurface: const Color(0xFFB8D4B9),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1F10),
        cardColor: const Color(0xFF172A18),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1F10),
          foregroundColor: Color(0xFFB8D4B9),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),

    // 10. Ceniza — contraste bajo, gris medio oscuro
    AppThemeOption(
      id: 'dark_ash',
      name: 'Ceniza',
      description: 'Gris suave, contraste bajo',
      isDark: true,
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF90A4AE),
          brightness: Brightness.dark,
          surface: const Color(0xFF2C2C2C),
          onSurface: const Color(0xFFBBBBBB),
        ),
        scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        cardColor: const Color(0xFF383838),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2C),
          foregroundColor: Color(0xFFBBBBBB),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),
  ];
}
