import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/favourites_provider.dart';
import 'package:mi_primer_proyecto/providers/music_provider.dart';
import 'package:mi_primer_proyecto/providers/profile_provider.dart';
import 'package:mi_primer_proyecto/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => FavouritesProvider()),
      // Agregar el nuevo proveedor
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => MusicProvider()),
    ],
    child: const SenaBeatsApp(),
    ),
  );
}

class SenaBeatsApp extends StatelessWidget {
  const SenaBeatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SENA Canciones',

      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}