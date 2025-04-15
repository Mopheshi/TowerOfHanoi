import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import 'game_state.dart';

class GameNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  Timer? _autoSolveTimer;
  List<List<int>> _solveMoves = [];
  int _currentSolveMove = 0;

  GameNotifier() : super(GameState(towers: [])) {
    _initializeGame(3);
  }

  /// Initializes the game with the specified number of disks.
  ///
  /// This method sets up the initial state of the game by creating three towers
  /// and adding disks to the first tower in descending order of size. It also
  /// resets the timer and auto-solve features to their default states.
  ///
  /// **Parameters:**
  /// - [diskCount]: The number of disks to initialize the game with.
  ///
  /// **Side Effects:**
  /// - Resets the game state, including towers, move count, and timer.
  /// - Prepares the game for manual play or auto-solving.
  void _initializeGame(int diskCount) {
    final diskColors = Colours.diskColors;

    // Create towers
    final towers = List.generate(3, (i) => Tower(id: i));

    // Add disks to first tower
    // for (int i = diskCount; i > 0; i--) {
    //   final colorIndex = (i - 1) % diskColors.length;
    //   towers[0] = towers[0].addDisk(
    //     Disk(size: i, color: diskColors[colorIndex]),
    //   );
    // }
    // Optimised adding logic
    towers[0] = towers[0].copyWith(
      disks: List.generate(diskCount, (index) {
        final size = diskCount - index;
        final colorIndex = (size - 1) % diskColors.length;
        return Disk(size: size, color: diskColors[colorIndex]);
      }),
    );

    // Reset the timer
    _timer?.cancel();
    _timer = null;

    // Reset auto-solve
    _autoSolveTimer?.cancel();
    _autoSolveTimer = null;
    _solveMoves = [];
    _currentSolveMove = 0;

    // state = GameState(towers: towers, diskCount: diskCount);
    state = GameState(
      towers: towers,
      diskCount: diskCount,
      isMusicPlaying: GameAudioPlayer.isBackgroundMusicPlaying,
    );
  }

  /// Handles the selection of a tower and the movement of disks.
  ///
  /// This method manages the logic for selecting a tower and moving disks between
  /// towers. If no tower is currently selected, it selects the tapped tower if it
  /// has disks. If a tower is already selected, it either deselects it (if the same
  /// tower is tapped) or attempts to move the top disk to the tapped tower. Audio
  /// feedback is provided based on the action (e.g., selection or move sounds).
  ///
  /// **Parameters:**
  /// - [towerId]: The ID of the tower that was tapped.
  ///
  /// **Side Effects:**
  /// - Updates the selected tower state.
  /// - Triggers disk movement if applicable.
  /// - Plays appropriate sound effects.
  void selectTower(int towerId) {
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

  /// Moves a disk from one tower to another if the move is valid.
  ///
  /// This private method performs the actual movement of a disk from the source
  /// tower to the destination tower. It checks if the move is legal (i.e., the disk
  /// can be placed on the destination tower based on size rules) and updates the
  /// game state accordingly. If the move is invalid, it plays an error sound and
  /// deselects the tower.
  ///
  /// **Parameters:**
  /// - [fromTowerId]: The ID of the tower to move the disk from.
  /// - [toTowerId]: The ID of the tower to move the disk to.
  ///
  /// **Side Effects:**
  /// - Updates the towers' disk stacks.
  /// - Increments the move counter.
  /// - Plays success or error sounds based on move validity.
  void _moveDisk(int fromTowerId, int toTowerId) {
    final newTowers = List<Tower>.from(state.towers);
    final disk = newTowers[fromTowerId].topDisk;
    if (disk != null && newTowers[toTowerId].canAcceptDisk(disk)) {
      newTowers[fromTowerId] = newTowers[fromTowerId].removeDisk();
      newTowers[toTowerId] = newTowers[toTowerId].addDisk(disk);
      GameAudioPlayer.playEffect(GameSounds.move);

      // Check if the game was not already playing
      bool wasPlaying = state.isPlaying;
      state = state.copyWith(
        towers: newTowers,
        moves: state.moves + 1,
        isPlaying: true,
      );

      if (!wasPlaying) {
        _startTimer();
      }

      // Delay clearing selection
      Timer(
        const Duration(milliseconds: 300),
        () => state = state.copyWith(selectedTowerId: null),
      );
      _checkWin();
    } else {
      GameAudioPlayer.playEffect(GameSounds.error);
      state = state.copyWith(selectedTowerId: null);
    }
  }

  /// Checks if the game has been won and handles win actions.
  ///
  /// This method evaluates the win condition by checking if all disks have been
  /// moved to either the second or third tower. If the condition is met, it stops
  /// the timer, plays win sounds, and updates the game state to reflect the victory.
  ///
  /// **Side Effects:**
  /// - Stops the game timer.
  /// - Triggers win audio effects.
  /// - Marks the game as won.
  void _checkWin() {
    // Game is won if all disks are on tower 2 or 3
    final tower2Complete = state.towers[1].disks.length == state.diskCount;
    final tower3Complete = state.towers[2].disks.length == state.diskCount;

    if (tower2Complete || tower3Complete) {
      _timer?.cancel();
      _timer = null;

      GameAudioPlayer.playEffect(GameSounds.clap);
      GameAudioPlayer.playEffect(GameSounds.win);

      state = state.copyWith(isPlaying: false, hasWon: true);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(seconds: state.seconds + 1);
    });
  }

  void changeDiskCount(int diskCount) {
    if (diskCount < 1) diskCount = 1;
    if (diskCount > 7) diskCount = 7;

    _initializeGame(diskCount);
  }

  void resetGame() {
    GameAudioPlayer.playEffect(GameSounds.reset);
    _initializeGame(state.diskCount);
  }

  /// Toggles the background music state.
  ///
  /// This method updates the game state to reflect the desired music
  /// playback status.
  ///
  /// **Parameters:**
  /// - [playMusic]: Whether music should be playing after this toggle.
  ///
  /// **Side Effects:**
  /// - Updates the isMusicPlaying property in the game state.
  void toggleMusicState([bool? playMusic]) {
    state = state.copyWith(isMusicPlaying: playMusic ?? !state.isMusicPlaying);
  }

  /// Initiates the auto-solving feature to solve the puzzle automatically.
  ///
  /// This method generates a sequence of moves to solve the Tower of Hanoi puzzle
  /// using a recursive algorithm. It resets the game state for auto-solving, starts
  /// a timer, and executes the moves step-by-step with a delay between each move.
  ///
  /// **Side Effects:**
  /// - Resets the game state for auto-solving.
  /// - Generates and stores the list of moves.
  /// - Executes moves with visual and audio feedback.
  void autoSolve() {
    if (state.isAutoSolving) return;

    // Reset the game if it's won
    if (state.hasWon) {
      resetGame();
    }

    // Generate solution moves
    _solveMoves = [];
    _generateSolveMoves(state.diskCount, 0, 1, 2);
    _currentSolveMove = 0;

    // Reset moves and timer
    _timer?.cancel();
    state = state.copyWith(
      moves: 0,
      seconds: 0,
      isPlaying: true,
      isAutoSolving: true,
      selectedTowerId: null,
    );

    _startTimer();
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
    _timer?.cancel();
    _autoSolveTimer?.cancel();
    super.dispose();
  }
}
