class Clothing {
  final String id;
  final String name;
  final String category; // Camisetas, Sneakers, Chaquetas, etc.
  final String imagePath; // Ruta local de la foto tomada con la cámara
  final bool isFromApi; // true = viene de Fake Store API, false = prenda propia

  Clothing({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    this.isFromApi = false,
  }); 
}