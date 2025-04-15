import '../models/tower.dart';

class GameState {
  final List<Tower> towers;
  final int? selectedTowerId;
  final int moves;
  final int diskCount;
  final int seconds;
  final bool isPlaying;
  final bool isAutoSolving;
  final bool hasWon;

  const GameState({
    required this.towers,
    this.selectedTowerId,
    this.moves = 0,
    this.diskCount = 3,
    this.seconds = 0,
    this.isPlaying = false,
    this.isAutoSolving = false,
    this.hasWon = false,
  });

  GameState copyWith({
    List<Tower>? towers,
    int? selectedTowerId,
    int? moves,
    int? diskCount,
    int? seconds,
    bool? isPlaying,
    bool? isAutoSolving,
    bool? hasWon,
  }) {
    return GameState(
      towers: towers ?? this.towers,
      selectedTowerId: selectedTowerId,
      moves: moves ?? this.moves,
      diskCount: diskCount ?? this.diskCount,
      seconds: seconds ?? this.seconds,
      isPlaying: isPlaying ?? this.isPlaying,
      isAutoSolving: isAutoSolving ?? this.isAutoSolving,
      hasWon: hasWon ?? this.hasWon,
    );
  }

  int get minimumMoves => (1 << diskCount) - 1; // 2^n - 1
}
