import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/game_provider.dart';
import '../../utils/utils.dart';
import '../widgets.dart';

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
      child: GradientContainer(
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
                child: Text('😢', style: const TextStyle(fontSize: 64)),
              ),
              h16,
              Text(
                "Time's Up!",
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              h8,
              Text(
                'You ran out of time!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              h24,
              StatRow(label: 'Disks', value: '${gameState.diskCount}'),
              StatRow(label: 'Moves', value: '${gameState.moves}'),
              StatRow(
                label: 'Time Limit',
                value: gameState.timeLimit.formatTime(),
              ),
              StatRow(
                label: 'Time Spent',
                value: gameState.timeSpent.formatTime(),
              ),
              h24,
              Text(
                'Try again with less disks or more time!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              h24,
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
                    h16,
                    ActionButton(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Auto Solve',
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
}
