import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';

class OutfitsScreen extends StatelessWidget {
  const OutfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wardrobeProvider = context.watch<WardrobeProvider>();
    final favs = wardrobeProvider.favouriteOutfits;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Outfits Favoritos')),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aún no tienes outfits favoritos',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toca el ❤️ en cualquier prenda para guardarla aquí',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favs.length,
              itemBuilder: (_, index) {
                final item = favs[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item.isFromApi
                          ? Image.network(
                              item.imagePath,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(item.imagePath),
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sugerir este outfit
                        IconButton(
                          icon: const Icon(
                            Icons.auto_awesome,
                            color: Colors.amberAccent,
                          ),
                          tooltip: 'Sugerir outfit',
                          onPressed: () {
                            wardrobeProvider.setSuggestedOutfit(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✨ Outfit sugerido activado'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        // Quitar de favoritos
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () =>
                              wardrobeProvider.toggleFavouriteOutfit(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
