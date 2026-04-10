import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clothing.dart';
import '../services/store_service.dart'; // Asegúrate de importar tu servicio

class WardrobeProvider extends ChangeNotifier {
  List<Clothing> _wardrobe = []; // Tu ropa (Cámara)
  List<Clothing> _apiClothing = []; // Ropa de la tienda (API)
  List<Clothing> _favouriteOutfits = [];
  Clothing? _suggestedOutfit;

  List<Clothing> get wardrobe => _wardrobe;
  List<Clothing> get favouriteOutfits => _favouriteOutfits;
  Clothing? get suggestedOutfit => _suggestedOutfit;

  final ImagePicker _picker = ImagePicker();
  final StoreService _storeService = StoreService();

  WardrobeProvider() {
    _loadFromDisk();
  }

  // ─── CARGAR ROPA DE LA API ──────────────────────────────────────────────
  // Este método lo llamarás desde el initState de wardrobe_screen.dart
  Future<void> loadApiClothing() async {
    try {
      final items = await _storeService.fetchSeasonSuggestions();
      _apiClothing = items;
      notifyListeners();
    } catch (e) {
      debugPrint("Error cargando API: $e");
    }
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

  // ─── ELIMINAR PRENDA ──────────────────────────────────────────────────────
  void removeClothing(Clothing item) {
    if (item.isFromApi) {
      _apiClothing.removeWhere((c) => c.id == item.id);
    } else {
      _wardrobe.removeWhere((c) => c.id == item.id);
      _saveToDisk();
    }
    notifyListeners();
  }

  // ─── FAVORITOS Y OUTFITS ──────────────────────────────────────────────────
  bool isFavourite(Clothing item) =>
      _favouriteOutfits.any((fav) => fav.id == item.id);

  void toggleFavouriteOutfit(Clothing item) {
    if (isFavourite(item)) {
      _favouriteOutfits.removeWhere((fav) => fav.id == item.id);
    } else {
      _favouriteOutfits.add(item);
    }
    _saveToDisk();
    notifyListeners();
  }

  void setSuggestedOutfit(Clothing item) {
    _suggestedOutfit = item;
    notifyListeners();
  }

  void clearSuggestedOutfit() {
    _suggestedOutfit = null;
    notifyListeners();
  }

  // ─── RANDOMIZE (Agitar) ───────────────────────────────────────────────────
  void randomizeOutfit() {
    // Mezclamos ambas listas para el aleatorio
    List<Clothing> all = [..._wardrobe, ..._apiClothing];
    if (all.isEmpty) return;
    all.shuffle();
    _suggestedOutfit = all.first;
    notifyListeners();
  }

  // ─── FILTRAR POR CATEGORÍA (API + USUARIO) ────────────────────────────────
  List<Clothing> getByCategory(String category) {
    // Combinamos las prendas locales y las de la API
    List<Clothing> combinedList = [..._wardrobe, ..._apiClothing];

    if (category == 'Todos') return combinedList;
    return combinedList.where((c) => c.category == category).toList();
  }

  // ─── PERSISTENCIA ────────────────────────────────────────────────────────
  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    // Solo guardamos la ropa del usuario (_wardrobe), no la de la API
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