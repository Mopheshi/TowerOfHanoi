import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../utils/game_audio_player.dart';
import '../widgets/widgets.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  /// Builds the main game screen UI, adapting to different orientations.
  ///
  /// This method constructs the user interface for the game, including the towers,
  /// control buttons, and statistics panel. It dynamically adjusts the layout for
  /// portrait and landscape orientations and displays a win dialog when the game
  /// is completed.
  ///
  /// **Parameters:**
  /// - [context]: The build context used for rendering the UI.
  /// - [ref]: The WidgetRef for accessing Riverpod providers.
  ///
  /// **Returns:**
  /// - A [Widget] representing the game screen layout.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    // Show win or lose dialog if game is over
    if (gameState.hasWon || gameState.hasLost) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) =>
                    gameState.hasWon ? const WinDialog() : const LoseDialog(),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 30,
            tooltip: gameState.isMusicPlaying ? 'Stop Music' : 'Play Music',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child:
                  gameState.isMusicPlaying
                      ? const Icon(
                        Icons.music_note_rounded,
                        key: ValueKey('playing'),
                      )
                      : const Icon(
                        Icons.music_off_rounded,
                        key: ValueKey('stopped'),
                      ),
            ),
            onPressed: () {
              final newMusicState = !gameState.isMusicPlaying;

              ref.read(gameProvider.notifier).toggleMusicState(newMusicState);

              if (newMusicState) {
                GameAudioPlayer.playBackgroundMusic();
              } else {
                GameAudioPlayer.pauseBackgroundMusic();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            MediaQuery.of(context).orientation == Orientation.landscape
                ? _buildLandscapeLayout(context)
                : _buildPortraitLayout(context),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Stats panel
        const StatsPanel(),

        // Game area with towers
        Expanded(flex: 3, child: _buildGameArea()),

        // Controls
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: GameControls(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        // Game area with towers
        Expanded(flex: 3, child: _buildGameArea()),

        // Controls and stats
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                StatsPanel(),
                SizedBox(height: 20),
                GameControls(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameArea() {
    return Consumer(
      builder: (context, ref, _) {
        final gameState = ref.watch(gameProvider);
        final towers = gameState.towers;

        return LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            final maxWidth = constraints.maxWidth;

            return Container(
              width: maxWidth,
              height: maxHeight,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  towers.length,
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TowerWidget(
                        tower: towers[i],
                        isSelected: gameState.selectedTowerId == i,
                        maxHeight: maxHeight * 0.85,
                        onTap:
                            () =>
                                ref.read(gameProvider.notifier).selectTower(i),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
