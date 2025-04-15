import 'package:flutter/services.dart';

import 'utilities.dart';

class OrientationInitializer {
  static Future<void> initialise() async {
    // Set preferred orientations
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      ll('Orientation set to portrait and landscape modes.');
    } on PlatformException catch (e) {
      ll('Failed to set orientation: $e');
    } catch (e) {
      ll('Error setting orientation: $e');
    }
  }
}
