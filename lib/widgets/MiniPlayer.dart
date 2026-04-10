import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();
    final track = musicProvider.currentTrack;

    // DIAGNÓSTICO SEGURO: Si no hay música, mostramos un aviso sutil
    // Esto te confirmará si el MainScreen está dejando el espacio para la barra
    if (track == null) {
      return const SizedBox.shrink(); // Cámbialo por un Container rojo si quieres ver el espacio
    }

    return Container(
      height: 80, // Un poco más alto para que luzca en el Pixel
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurple[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [const BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(track.image, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(track.artist, maxLines: 1),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // BOTÓN PLAY / PAUSA
            IconButton(
              icon: Icon(musicProvider.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => musicProvider.playTrack(track),
            ),
            // BOTÓN CERRAR (X)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => musicProvider.stop(), // Detiene y limpia el track
            ),
          ],
        ),
      ),
    );
  }
}