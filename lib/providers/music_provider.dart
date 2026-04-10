import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/track.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Track? _currentTrack;
  bool _isPlaying = false;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  // Escuchar si la cancion termina sola

  MusicProvider() {
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> playTrack(Track track) async {
    if (_currentTrack?.id == track.id){
      if (_isPlaying){
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } else {
      _currentTrack = track;
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(track.previewUrl));
      _isPlaying = false;
    }

    if (await Vibration.hasVibrator() ?? false){
      Vibration.vibrate(duration: 40, amplitude: 100);
    }
    notifyListeners();
  }
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentTrack = null;
    _isPlaying = false;
    notifyListeners();
  }
}