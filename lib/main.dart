import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/wardrove_provider.dart';
import 'package:mi_primer_proyecto/providers/profile_provider.dart';
import 'package:mi_primer_proyecto/providers/theme_provider.dart';
import 'package:mi_primer_proyecto/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const StyleStackApp(),
    ),
  );
}

class StyleStackApp extends StatelessWidget {
  const StyleStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StyleStack',
      theme: themeProvider.themeData,
      home: const MainScreen(),
    );
  }
}