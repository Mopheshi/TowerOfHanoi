import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_provider.dart';
import '../utils/utils.dart';
import 'action_button.dart';

class WinDialog extends ConsumerStatefulWidget {
  const WinDialog({super.key});

  @override
  ConsumerState<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends ConsumerState<WinDialog>
    with SingleTickerProviderStateMixin {
  final delayDuration = const Duration(milliseconds: 300);
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(delayDuration, () {
      setState(() => _isExpanded = true);
      Future.delayed(delayDuration, () => setState(() => _isExpanded = false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surfaceBright,
              Theme.of(context).colorScheme.surfaceDim,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isExpanded ? 1.5 : 1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You solved the puzzle!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildStatRow('Moves', '${gameState.moves}'),
              _buildStatRow('Minimum Moves', '${gameState.minimumMoves}'),
              _buildStatRow('Time Limit', gameState.timeLimit.formatTime()),
              _buildStatRow('Time Spent', gameState.timeSpent.formatTime()),
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
