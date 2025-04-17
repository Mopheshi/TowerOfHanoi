import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class GameControls extends ConsumerWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDiskCountSelector(gameState, gameNotifier),
              const SizedBox(height: 16),
              _buildActionButtons(gameState, gameNotifier, context),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDiskCountSelector(gameState, gameNotifier),
              const SizedBox(height: 16),
              _buildActionButtons(gameState, gameNotifier, context),
            ],
          );
        }
      },
    );
  }

  Widget _buildDiskCountSelector(
    GameState gameState,
    GameNotifier gameNotifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Disks:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        CircleButton(
          icon: Icons.remove_rounded,
          onPressed:
              (gameState.diskCount > minDiskCount &&
                      !gameState.isPlaying &&
                      !gameState.isAutoSolving)
                  ? () => gameNotifier.changeDiskCount(gameState.diskCount - 1)
                  : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${gameState.diskCount}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CircleButton(
          icon: Icons.add_rounded,
          onPressed:
              (gameState.diskCount < maxDiskCount &&
                      !gameState.isPlaying &&
                      !gameState.isAutoSolving)
                  ? () => gameNotifier.changeDiskCount(gameState.diskCount + 1)
                  : null,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    GameState gameState,
    GameNotifier gameNotifier,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton(
            label: 'Reset',
            icon: Icons.refresh_rounded,
            onPressed: () => gameNotifier.resetGame(),
            backgroundColor: Colours.orangeColor,
          ),
          const SizedBox(width: 16),
          ActionButton(
            label: 'Auto Solve',
            icon: Icons.auto_awesome_rounded,
            onPressed:
                gameState.isAutoSolving ? null : () => gameNotifier.autoSolve(),
            backgroundColor: Colours.blueColor,
          ),
        ],
      ),
    );
  }
}
