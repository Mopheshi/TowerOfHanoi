import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/game_provider.dart';
import '../../utils/utils.dart';

class MusicToggle extends ConsumerWidget {
  const MusicToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    return IconButton(
      iconSize: 30,
      tooltip: gameState.isMusicPlaying ? 'Stop Music' : 'Play Music',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child:
            gameState.isMusicPlaying
                ? const Icon(Icons.music_note_rounded, key: ValueKey('playing'))
                : const Icon(Icons.music_off_rounded, key: ValueKey('stopped')),
      ),
      onPressed: () {
        GameAudioPlayer.playEffect(GameSounds.click);

        final newMusicState = !gameState.isMusicPlaying;

        ref.read(gameProvider.notifier).toggleMusicState(newMusicState);

        if (newMusicState) {
          GameAudioPlayer.playBackgroundMusic();
        } else {
          GameAudioPlayer.pauseBackgroundMusic();
        }
      },
    );
  }
}
