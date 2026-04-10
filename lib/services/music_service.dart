import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class MusicService {
  // URL base de iTunes Search
  static const String _baseUrl = 'https://itunes.apple.com/search';

  Future<List<Track>> searchTracks(String searchTerm) async {
    // Construimos la URL con parámetros: 
    // term: lo que el usuario escribe
    // entity: limitamos a solo canciones (evitamos podcasts o películas)
    // limit: traemos solo 20 para no saturar la web
    final url = Uri.parse('$_baseUrl?term=$searchTerm&entity=song&limit=20');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['results'];

        // Mapeamos el JSON dinámico a nuestra lista de objetos Track
        return results.map((item) {
          return Track(
            // iTunes usa trackId como número, lo pasamos a String para nuestro modelo
            id: item['trackId'].toString(), 
            title: item['trackName'] ?? 'Sin título',
            artist: item['artistName'] ?? 'Artista desconocido',
            // Usamos la imagen de 100x100 que nos da la API
            image: item['artworkUrl100'] ?? 'https://via.placeholder.com/150',
            previewUrl: item['previewUrl'] ?? ''
          );
        }).toList();
      } else {
        throw 'Error en la respuesta del servidor: ${response.statusCode}';
      }
    } catch (e) {
      // Manejo básico de errores (ej. sin internet)
      throw 'No se pudo conectar con la API de música: $e';
    }
  }
}