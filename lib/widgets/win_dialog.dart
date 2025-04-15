import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_provider.dart';
import '../utils/utils.dart';
import 'action_button.dart';

class WinDialog extends ConsumerWidget {
  const WinDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      elevation: 20,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You solved the puzzle!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withAlpha(204),
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow('Moves', '${gameState.moves}'),
            _buildStatRow('Minimum Moves', '${gameState.minimumMoves}'),
            _buildStatRow('Time', gameState.seconds.formatTime()),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  icon: Icons.play_arrow,
                  label: 'Play Again',
                  backgroundColor: Colors.green,
                  onPressed: () {
                    GameAudioPlayer.playEffect(GameSounds.click);
                    ref.read(gameProvider.notifier).resetGame();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.white.withAlpha(204)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
