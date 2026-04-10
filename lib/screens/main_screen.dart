import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/screens/search_screen.dart';
import 'package:mi_primer_proyecto/screens/favourites_screen.dart';
import 'package:mi_primer_proyecto/screens/profile_screen.dart';
import 'package:mi_primer_proyecto/widgets/MiniPlayer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  final List<Widget> _pages = [
    const SearchScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Mantener el estado de las pantallas aunque se cambie de screen
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Buscar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favoritos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
