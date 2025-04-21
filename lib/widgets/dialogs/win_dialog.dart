import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/game_provider.dart';
import '../../utils/utils.dart';
import '../widgets.dart';

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
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 64,
                ),
              ),
              h16,
              Text(
                'Congratulations!',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              h8,
              Text(
                'You solved the puzzle!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
              h24,
              StatRow(label: 'Moves', value: '${gameState.moves}'),
              StatRow(
                label: 'Minimum Moves',
                value: '${gameState.minimumMoves}',
              ),
              StatRow(
                label: 'Time Limit',
                value: gameState.timeLimit.formatTime(),
              ),
              StatRow(
                label: 'Time Spent',
                value: gameState.timeSpent.formatTime(),
              ),
              h24,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionButton(
                    icon: Icons.play_arrow,
                    label: 'Play Again',
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
}
