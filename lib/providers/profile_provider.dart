import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileProvider extends ChangeNotifier{
  File? _imageFile; // File, no String
  File? get imageFile => _imageFile;

  final ImagePicker _picker = ImagePicker();
  ProfileProvider(){
    _loadPhotoPath();
  }

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera, // Viene de la camara
      imageQuality: 50 // Comprimir para no saturar la memoria
    );
    if (photo != null){
      _imageFile = File(photo.path); // Guardar el archivo en la variable
      _savePhotoPath(photo.path);
      notifyListeners(); // Avisarle a la UI para que se muestre la foto
    }
  }

  // Persistir la ruta
  _savePhotoPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_photo_path', path);
  }

  _loadPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    final String? path = prefs.getString('profile_photo_path');
    if (path != null) {
      _imageFile = File(path);
      notifyListeners();
    }
  }
}