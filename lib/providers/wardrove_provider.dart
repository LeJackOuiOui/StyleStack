import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/clothing.dart';

class WardrobeProvider extends ChangeNotifier {
  List<Clothing> _wardrobe = [];
  List<Clothing> _favouriteOutfits = [];
  Clothing? _suggestedOutfit; // El "MiniPlayer" de StyleStack

  List<Clothing> get wardrobe => _wardrobe;
  List<Clothing> get favouriteOutfits => _favouriteOutfits;
  Clothing? get suggestedOutfit => _suggestedOutfit;

  final ImagePicker _picker = ImagePicker();

  WardrobeProvider() {
    _loadFromDisk();
  }

  // ─── AGREGAR PRENDA CON CÁMARA ───────────────────────────────────────────
  Future<void> addClothingWithCamera({
    required String name,
    required String category,
  }) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );

    if (photo != null) {
      final newItem = Clothing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: category,
        imagePath: photo.path,
        isFromApi: false,
      );
      _wardrobe.add(newItem);
      _saveToDisk();
      notifyListeners();
    }
  }

  // ─── AGREGAR PRENDA DESDE API (sin cámara) ───────────────────────────────
  void addClothingFromApi(Clothing item) {
    final alreadyExists = _wardrobe.any((c) => c.id == item.id);
    if (!alreadyExists) {
      _wardrobe.add(item);
      _saveToDisk();
      notifyListeners();
    }
  }

  // ─── ELIMINAR PRENDA (con vibración) ─────────────────────────────────────
  Future<void> removeClothing(Clothing item) async {
    _wardrobe.removeWhere((c) => c.id == item.id);
    _favouriteOutfits.removeWhere((c) => c.id == item.id);

    // Feedback háptico al eliminar
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 80, amplitude: 150);
    }

    _saveToDisk();
    notifyListeners();
  }

  // ─── OUTFIT SUGERIDO (el "MiniPlayer") ───────────────────────────────────
  void setSuggestedOutfit(Clothing? item) {
    _suggestedOutfit = item;
    notifyListeners();
  }

  void clearSuggestedOutfit() {
    _suggestedOutfit = null;
    notifyListeners();
  }

  // ─── FILTRAR POR CATEGORÍA ────────────────────────────────────────────────
  List<Clothing> getByCategory(String category) {
    if (category == 'Todos') return _wardrobe;
    return _wardrobe.where((c) => c.category == category).toList();
  }

  // ─── PERSISTENCIA ────────────────────────────────────────────────────────
  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final wardrobeData = json.encode(_wardrobe.map((c) => c.toMap()).toList());
    final favsData = json.encode(
      _favouriteOutfits.map((c) => c.toMap()).toList(),
    );
    await prefs.setString('wardrobe', wardrobeData);
    await prefs.setString('favourite_outfits', favsData);
  }

  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();

    final wardrobeRaw = prefs.getString('wardrobe');
    if (wardrobeRaw != null) {
      final List decoded = json.decode(wardrobeRaw);
      _wardrobe = decoded.map((m) => Clothing.fromMap(m)).toList();
    }

    final favsRaw = prefs.getString('favourite_outfits');
    if (favsRaw != null) {
      final List decoded = json.decode(favsRaw);
      _favouriteOutfits = decoded.map((m) => Clothing.fromMap(m)).toList();
    }

    notifyListeners();
  }
}
