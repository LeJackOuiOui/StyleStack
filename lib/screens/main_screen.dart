import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/screens/wardrobe_screen.dart';
import 'package:mi_primer_proyecto/screens/outfits_screen.dart';
import 'package:mi_primer_proyecto/screens/profile_screen.dart';
import 'package:mi_primer_proyecto/widgets/outfit_mini_player.dart';
import 'package:mi_primer_proyecto/widgets/shake_detector.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const WardrobeScreen(),
    const OutfitsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // ShakeDetector envuelve toda la app para detectar el gesto en cualquier pantalla
    return ShakeDetector(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OutfitMiniPlayer(),
            BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.checkroom),
                  label: 'Guardarropa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Outfits',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}