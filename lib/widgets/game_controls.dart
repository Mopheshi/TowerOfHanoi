import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../utils/colours.dart';
import '../utils/constants.dart';
import 'widgets.dart';

class GameControls extends ConsumerWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    final isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLandscape) {
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
              gameState.diskCount > minDiskCount
                  ? () => gameNotifier.changeDiskCount(gameState.diskCount - 1)
                  : null,
        ),
        Container(
          alignment: Alignment.center,
          width: 40,
          child: Text(
            '${gameState.diskCount}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        CircleButton(
          icon: Icons.add_rounded,
          onPressed:
              gameState.diskCount < maxDiskCount
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
