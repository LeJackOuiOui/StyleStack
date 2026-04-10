import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import '../providers/wardrove_provider.dart';

class ShakeDetector extends StatefulWidget {
  final Widget child;
  const ShakeDetector({super.key, required this.child});

  @override
  State<ShakeDetector> createState() => _ShakeDetectorState();
}

class _ShakeDetectorState extends State<ShakeDetector> {
  StreamSubscription<AccelerometerEvent>? _subscription;

  // ── Parámetros de detección ──────────────────────────────────────────────
  static const double _shakeThreshold = 18.0; // m/s² para ignorar movimiento suave
  static const int _minTimeBetweenShakes = 1200; // ms entre shakes válidos

  DateTime _lastShake = DateTime(0);

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Magnitud del vector de aceleración (sin gravedad no es posible con accelerometer)
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // La gravedad terrestre es ~9.8 m/s², si supera threshold hay agitación real
      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        final diff = now.difference(_lastShake).inMilliseconds;

        if (diff > _minTimeBetweenShakes) {
          _lastShake = now;
          _onShake();
        }
      }
    });
  }

  Future<void> _onShake() async {
    final wardrobeProvider = context.read<WardrobeProvider>();

    if (wardrobeProvider.wardrobe.isEmpty) return;

    wardrobeProvider.randomizeOutfit();

    // Vibración doble para feedback del shake
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 80, 100, 120]);
    }

    // Snackbar con el nombre del outfit sugerido
    if (mounted) {
      final outfit = wardrobeProvider.suggestedOutfit;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('🎲 ', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shake to Randomize',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (outfit != null)
                      Text(
                        outfit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
