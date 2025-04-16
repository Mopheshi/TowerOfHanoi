import 'package:flutter/material.dart';

import '../screens/game_screen.dart';
import 'utils/utils.dart';

class TowerOfHanoi extends StatelessWidget {
  const TowerOfHanoi({super.key});

  @override
  Widget build(BuildContext context) {
    // Start background music after first frame
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => GameAudioPlayer.playBackgroundMusic(),
    );

    return MaterialApp(
      title: appName,
      theme: appTheme,
      home: const GameScreen(),
    );
  }
}
