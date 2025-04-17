import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_provider.dart';
import '../utils/utils.dart';
import 'action_button.dart';

class LoseDialog extends ConsumerStatefulWidget {
  const LoseDialog({super.key});

  @override
  ConsumerState<LoseDialog> createState() => _LoseDialogState();
}

class _LoseDialogState extends ConsumerState<LoseDialog>
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
                child: Icon(Icons.error_rounded, color: Colors.red, size: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                "Time's Up!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You ran out of time!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildStatRow('Disks', '${gameState.diskCount}'),
              _buildStatRow('Moves', '${gameState.moves}'),
              _buildStatRow('Time Limit', gameState.timeLimit.formatTime()),
              const SizedBox(height: 24),
              Text(
                'Try again with less disks or more time!',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(
                      icon: Icons.refresh_rounded,
                      label: 'Retry',
                      backgroundColor: Colors.orange,
                      onPressed: () {
                        GameAudioPlayer.playEffect(GameSounds.click);
                        ref.read(gameProvider.notifier).resetGame();
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 16),
                    ActionButton(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Auto Solve',
                      backgroundColor: Colors.green,
                      onPressed: () {
                        GameAudioPlayer.playEffect(GameSounds.click);
                        ref.read(gameProvider.notifier).autoSolve();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
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
