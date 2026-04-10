import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrove_provider.dart';

class OutfitMiniPlayer extends StatelessWidget {
  const OutfitMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final wardrobeProvider = context.watch<WardrobeProvider>();
    final outfit = wardrobeProvider.suggestedOutfit;

    // Si no hay outfit sugerido, no ocupa espacio
    if (outfit == null) return const SizedBox.shrink();

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[800]!, Colors.indigo[700]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: outfit.isFromApi
              // Imagen de red (Fake Store API)
              ? Image.network(
                  outfit.imagePath,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.checkroom, size: 40),
                )
              // Imagen local (foto de cámara)
              : Image.file(
                  File(outfit.imagePath),
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.checkroom, size: 40),
                ),
        ),
        title: Text(
          '✨ Outfit Sugerido',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          outfit.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Marcar / desmarcar favorito
            IconButton(
              icon: Icon(
                wardrobeProvider.isFavourite(outfit)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.pinkAccent,
              ),
              onPressed: () =>
                  wardrobeProvider.toggleFavouriteOutfit(outfit),
            ),
            // Cerrar el mini player
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () => wardrobeProvider.clearSuggestedOutfit(),
            ),
          ],
        ),
      ),
    );
  }
}
