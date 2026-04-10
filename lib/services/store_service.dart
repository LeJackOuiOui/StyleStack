import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clothing.dart';

class StoreService {
  // Cambiamos a la URL base para tener más flexibilidad
  static const String _baseUrl =
      'https://fakestoreapi.com/products/category/clothing';

  Future<List<Clothing>> fetchSeasonSuggestions() async {
    try {
      // Consultamos la categoría de ropa de hombre (puedes añadir mujer después)
      final response = await http.get(
        Uri.parse('$_baseUrl/category/men\'s clothing'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        return data.map((item) {
          final String title = (item['title'] ?? '').toString().toLowerCase();

          // Lógica para mapear categorías de la API a las de tu App
          String mappedCategory = 'Camisetas'; // Por defecto
          if (title.contains('jacket')) mappedCategory = 'Chaquetas';
          if (title.contains('pant') || title.contains('jean'))
            mappedCategory = 'Pantalones';
          if (title.contains('shirt')) mappedCategory = 'Camisetas';

          return Clothing(
            id: 'api_${item['id']}',
            name: item['title'] ?? 'Prenda API',
            category: mappedCategory, // Ahora coincide con tus FilterChips
            imagePath: item['image'] ?? '',
            isFromApi: true,
          );
        }).toList();
      } else {
        throw 'Error del servidor: ${response.statusCode}';
      }
    } catch (e) {
      throw 'No se pudo conectar con la tienda: $e';
    }
  }
}