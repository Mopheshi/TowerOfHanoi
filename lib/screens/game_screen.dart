import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    _listenToRulesStateChanges();
  }

  /// Listen to rules state changes
  void _listenToRulesStateChanges() {
    ref.listenManual<bool>(rulesProvider, (previous, next) {
      if (!next && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const RulesDialog(),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initial check for first launch
    final hasAcceptedRules = ref.read(rulesProvider);
    if (!hasAcceptedRules) ref.read(rulesProvider.notifier).acceptRules();

    final gameState = ref.watch(gameProvider);

    // Show win or lose dialog if game is over
    if ((gameState.hasWon || gameState.hasLost) &&
        (ModalRoute.of(context)?.isCurrent ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) =>
                  gameState.hasWon ? const WinDialog() : const LoseDialog(),
        );
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
        actions: [MusicToggle(), AboutIcon()],
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
        h16,
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
