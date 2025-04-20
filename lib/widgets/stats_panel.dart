import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';

class StatsPanel extends ConsumerStatefulWidget {
  const StatsPanel({super.key});

  @override
  ConsumerState<StatsPanel> createState() => _StatsPanelState();
}

class _StatsPanelState extends ConsumerState<StatsPanel> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer to prevent duplicates
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Prevent setState after disposal
      setState(() => _elapsedSeconds++);
      ll('Elapsed seconds: $_elapsedSeconds');
      final gameState = ref.read(gameProvider);
      if (_elapsedSeconds >= gameState.timeLimit && gameState.isPlaying) {
        ref.read(gameProvider.notifier).handleGameOver();
        _timer?.cancel();
      }
    });
    ll('Timer started');
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;

    // Update the timeSpent in the GameState
    ref.read(gameProvider.notifier).updateGameState(timeSpent: _elapsedSeconds);

    setState(() => _elapsedSeconds = 0);
    ll('Timer stopped');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    if (gameState.isPlaying && _timer == null) {
      _startTimer();
    } else if (!gameState.isPlaying && _timer != null) {
      _stopTimer();
    }

    final remainingTime = gameState.timeLimit - _elapsedSeconds;
    final displayTime = remainingTime > 0 ? remainingTime : 0;

    final timeColor =
        displayTime < gameState.timeLimit * 0.25
            ? Colors.red
            : displayTime < gameState.timeLimit * 0.5
            ? Colors.orange
            : Colors.green;

    return Container(
      margin: const EdgeInsets.all(16),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              label: 'Moves',
              value: '${gameState.moves}',
              icon: Icons.swap_horiz_rounded,
              color: Colors.blue,
            ),
            _buildStatItem(
              label: 'Min Moves',
              value: '${gameState.minimumMoves}',
              icon: Icons.trending_down_rounded,
              color: Colors.orange,
            ),
            _buildStatItem(
              label: 'Time Left',
              value: displayTime.formatTime(),
              icon: Icons.hourglass_bottom_rounded,
              color: timeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<Color?>(
          tween: ColorTween(begin: Colors.transparent, end: color),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder:
              (context, animatedColor, child) =>
                  Icon(icon, color: animatedColor, size: 30),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(204),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
