import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/music_service.dart';
import '../providers/favourites_provider.dart';
import '../providers/music_provider.dart'; // <--- 1. Importa el nuevo proveedor
import '../models/track.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Track> _results = [];
  bool _isLoading = false;

  // 2. BORRAMOS el AudioPlayer local y el _currentPlayingId. 
  // Ya no los necesitamos aquí porque viven en el MusicProvider.

  void _search(String query) async {
    setState(() => _isLoading = true);
    final results = await MusicService().searchTracks(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavouritesProvider>();
    
    // 3. ESCUCHAMOS al proveedor de música global
    final musicProvider = context.watch<MusicProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SENA Beats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Buscar artista o canción...',
                prefixIcon: const Icon(Icons.music_note),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final track = _results[index];
              final isFav = favProvider.favourites.any((t) => t.id == track.id);
              
              // 4. Verificamos si ESTA canción específica es la que está sonando globalmente
              final isCurrentTrack = musicProvider.currentTrack?.id == track.id;
              final isPlaying = isCurrentTrack && musicProvider.isPlaying;

              return ListTile(
                leading: GestureDetector(
                  // 5. Llamamos al método global. Esto activará la vibración y la barra fija.
                  onTap: () => musicProvider.playTrack(track),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(track.image, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      // El icono ahora refleja el estado GLOBAL
                      Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 40,
                      )
                    ],
                  ),
                ),
                title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(track.artist),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () => favProvider.toggleFavourite(track),
                ),
              );
            },
          ),
    );
  }
}