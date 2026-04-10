import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';

class FavouritesProvider extends ChangeNotifier {
  List<Track> _favourites = [];
  List<Track> get favourites => _favourites;

  FavouritesProvider (){
    _loadFromDisk(); // Cargar los favoritos al iniciar la app
  }

  void toggleFavourite(Track track){
    final isExist = _favourites.any((t) => t.id == track.id);
    if (isExist){
      _favourites.removeWhere((t) => t.id == track.id);
    } else {
      _favourites.add(track);
    }
    _saveToDisk();
    notifyListeners(); // Avisar a todas las demas screens
  }

  // Logica para la persistencia

  void _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_favourites.map((t) => t.toMap()).toList());
    await prefs.setString('my_favourites', data);
  }

  void _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('my_favourites');
    if (data != null){
      final List decoded = json.decode(data);
      _favourites = decoded.map((m) => Track.fromMap(m)).toList();
      notifyListeners();
    }
  }
}