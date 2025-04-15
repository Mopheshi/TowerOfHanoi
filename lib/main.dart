import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tower_of_hanoi.dart';
import 'utils/utils.dart';

/// The entry point of the application.
///
/// This function initializes the Flutter app, configures device orientations,
/// sets up the audio system, and runs the main application widget. It serves as
/// the starting point for the Tower of Hanoi game.
///
/// **Side Effects:**
/// - Ensures the app runs in supported orientations.
/// - Initializes audio playback for background music.
/// - Launches the main app UI.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize device orientation
  await OrientationInitializer.initialise();

  // Initialize audio
  await GameAudioPlayer.initialize();

  runApp(const ProviderScope(child: TowerOfHanoi()));
}
