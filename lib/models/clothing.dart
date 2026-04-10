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

  Map<String, dynamic> toMap() => {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'isFromApi': isFromApi,
    };

  factory Clothing.fromMap(Map<String, dynamic> map) => Clothing(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      imagePath: map['imagePath'],
      isFromApi: map['isFromApi'] ?? false,
    );
}