import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import 'game_state.dart';

class GameNotifier extends StateNotifier<GameState> {
  Timer? _autoSolveTimer, _selectionTimer;
  List<List<int>> _solveMoves = [];
  int _currentSolveMove = 0;

  GameNotifier() : super(GameState(towers: [])) {
    _initializeGame(minDiskCount);
    GameAudioPlayer.playBackgroundMusic().then(
      (_) => state = state.copyWith(isMusicPlaying: true),
    );
  }

  void _initializeGame(int diskCount) {
    final diskColors = Colours.diskColors;
    final towers = List.generate(3, (i) => Tower(id: i));
    towers[0] = towers[0].copyWith(
      disks: List.generate(diskCount, (index) {
        final size = diskCount - index;
        final colorIndex = (size - 1) % diskColors.length;
        return Disk(size: size, color: diskColors[colorIndex]);
      }),
    );

    _autoSolveTimer?.cancel();
    _autoSolveTimer = null;
    _solveMoves = [];
    _currentSolveMove = 0;

    final timeLimit = GameState.calculateTimeLimit(diskCount);

    state = GameState(
      towers: towers,
      diskCount: diskCount,
      isMusicPlaying: state.isMusicPlaying,
      timeLimit: timeLimit,
    );

    if (!state.isMusicPlaying) GameAudioPlayer.playBackgroundMusic();
  }

  void selectTower(int towerId) {
    _selectionTimer?.cancel();
    if (state.selectedTowerId == null) {
      if (state.towers[towerId].topDisk != null) {
        GameAudioPlayer.playEffect(GameSounds.select);
        state = state.copyWith(selectedTowerId: towerId);
      }
    } else if (state.selectedTowerId == towerId) {
      GameAudioPlayer.playEffect(GameSounds.deselect);
      state = state.copyWith(selectedTowerId: null);
    } else {
      _moveDisk(state.selectedTowerId!, towerId);
    }
  }

  void _moveDisk(int fromTowerId, int toTowerId) {
    final newTowers = List<Tower>.from(state.towers);
    final disk = newTowers[fromTowerId].topDisk;
    if (disk != null && newTowers[toTowerId].canAcceptDisk(disk)) {
      newTowers[fromTowerId] = newTowers[fromTowerId].removeDisk();
      newTowers[toTowerId] = newTowers[toTowerId].addDisk(disk);
      GameAudioPlayer.playEffect(GameSounds.move);

      state = state.copyWith(
        towers: newTowers,
        moves: state.moves + 1,
        isPlaying: true,
        selectedTowerId: null,
      );

      _checkWin();
    } else {
      GameAudioPlayer.playEffect(GameSounds.error);
      state = state.copyWith(selectedTowerId: null);
    }
  }

  void _checkWin() {
    final tower2Complete = state.towers[1].disks.length == state.diskCount;
    final tower3Complete = state.towers[2].disks.length == state.diskCount;

    if (tower2Complete || tower3Complete) {
      GameAudioPlayer.playEffect(GameSounds.clap);
      GameAudioPlayer.playEffect(GameSounds.win);
      state = state.copyWith(isPlaying: false, hasWon: true);
    }
  }

  void changeDiskCount(int diskCount) {
    if (diskCount < 1) diskCount = 1;
    if (diskCount > maxDiskCount) diskCount = maxDiskCount;
    final timeLimit = GameState.calculateTimeLimit(diskCount);
    state = state.copyWith(diskCount: diskCount, timeLimit: timeLimit);
    _initializeGame(diskCount);
  }

  void resetGame() {
    GameAudioPlayer.playEffect(GameSounds.reset);
    _initializeGame(state.diskCount);
  }

  void toggleMusicState([bool? playMusic]) {
    state = state.copyWith(isMusicPlaying: playMusic ?? !state.isMusicPlaying);
  }

  void handleGameOver() {
    _autoSolveTimer?.cancel();
    GameAudioPlayer.playEffect(GameSounds.lost);
    state = state.copyWith(
      isPlaying: false,
      hasLost: true,
      timeSpent: state.timeSpent,
      isAutoSolving: false,
      selectedTowerId: null,
    );
  }

  void updateGameState({
    List<Tower>? towers,
    int? selectedTowerId,
    int? moves,
    int? diskCount,
    int? timeSpent,
    int? timeLimit,
    bool? isPlaying,
    bool? isAutoSolving,
    bool? hasWon,
    bool? hasLost,
    bool? isMusicPlaying,
  }) {
    state = state.copyWith(
      towers: towers ?? state.towers,
      selectedTowerId: selectedTowerId ?? state.selectedTowerId,
      moves: moves ?? state.moves,
      diskCount: diskCount ?? state.diskCount,
      timeSpent: timeSpent ?? state.timeSpent,
      timeLimit: timeLimit ?? state.timeLimit,
      isPlaying: isPlaying ?? state.isPlaying,
      isAutoSolving: isAutoSolving ?? state.isAutoSolving,
      hasWon: hasWon ?? state.hasWon,
      hasLost: hasLost ?? state.hasLost,
      isMusicPlaying: isMusicPlaying ?? state.isMusicPlaying,
    );
  }

  void autoSolve() {
    if (state.isAutoSolving) return;
    if (state.hasWon || state.hasLost) resetGame();

    _solveMoves = [];
    _generateSolveMoves(state.diskCount, 0, 1, 2);
    _currentSolveMove = 0;

    state = state.copyWith(
      moves: 0,
      isPlaying: true,
      isAutoSolving: true,
      selectedTowerId: null,
      hasLost: false,
    );

    _executeNextSolveMove();
  }

  void _generateSolveMoves(int n, int source, int auxiliary, int target) {
    if (n > 0) {
      _generateSolveMoves(n - 1, source, target, auxiliary);
      _solveMoves.add([source, target]);
      _generateSolveMoves(n - 1, auxiliary, source, target);
    }
  }

  void _executeNextSolveMove() {
    if (_currentSolveMove >= _solveMoves.length) {
      state = state.copyWith(isAutoSolving: false);
      return;
    }

    final move = _solveMoves[_currentSolveMove];
    final fromTowerId = move[0];
    final toTowerId = move[1];

    _autoSolveTimer?.cancel();
    _autoSolveTimer = Timer(const Duration(milliseconds: 600), () {
      _moveDisk(fromTowerId, toTowerId);
      _currentSolveMove++;
      _executeNextSolveMove();
    });
  }

  @override
  void dispose() {
    _autoSolveTimer?.cancel();
    _selectionTimer?.cancel();
    super.dispose();
  }
}
