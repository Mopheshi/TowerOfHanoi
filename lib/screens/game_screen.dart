import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_provider.dart';
import '../utils/constants.dart';
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
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Show win dialog if game is won
    if (gameState.hasWon) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const WinDialog(),
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
      ),
      body: SafeArea(
        child:
            isLandscape
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
