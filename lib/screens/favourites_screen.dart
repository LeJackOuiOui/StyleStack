import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accedemos a la lista de favoritos global
    final favProvider = context.watch<FavouritesProvider>();
    final favs = favProvider.favourites;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: favs.isEmpty
          ? const Center(child: Text('Aún no tienes canciones favoritas'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final track = favs[index];
                return ListTile(
                  leading: Image.network(track.image),
                  title: Text(track.title),
                  subtitle: Text(track.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => favProvider.toggleFavourite(track),
                  ),
                );
              },
            ),
    );
  }
}