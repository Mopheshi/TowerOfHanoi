import '../models/tower.dart';

class GameState {
  final List<Tower> towers;
  final int? selectedTowerId;
  final int moves;
  final int diskCount;
  final int seconds;
  final int timeLimit;
  final bool isPlaying;
  final bool isAutoSolving;
  final bool hasWon;
  final bool hasLost;
  final bool isMusicPlaying;

  const GameState({
    required this.towers,
    this.selectedTowerId,
    this.moves = 0,
    this.diskCount = 3,
    this.seconds = 0,
    this.timeLimit = 0,
    this.isPlaying = false,
    this.isAutoSolving = false,
    this.hasWon = false,
    this.hasLost = false,
    this.isMusicPlaying = false,
  });

  GameState copyWith({
    List<Tower>? towers,
    int? selectedTowerId,
    int? moves,
    int? diskCount,
    int? seconds,
    int? timeLimit,
    bool? isPlaying,
    bool? isAutoSolving,
    bool? hasWon,
    bool? hasLost,
    bool? isMusicPlaying,
  }) {
    return GameState(
      towers: towers ?? this.towers,
      selectedTowerId: selectedTowerId,
      moves: moves ?? this.moves,
      diskCount: diskCount ?? this.diskCount,
      seconds: seconds ?? this.seconds,
      timeLimit: timeLimit ?? this.timeLimit,
      isPlaying: isPlaying ?? this.isPlaying,
      isAutoSolving: isAutoSolving ?? this.isAutoSolving,
      hasWon: hasWon ?? this.hasWon,
      hasLost: hasLost ?? this.hasLost,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
    );
  }

  int get minimumMoves => (1 << diskCount) - 1; // 2^n - 1

  // Calculate remaining time
  int get remainingTime => timeLimit - seconds > 0 ? timeLimit - seconds : 0;

  /// Calculate recommended time limit based on disk count
  /// This gives players approximately 2-3 seconds per minimum move required
  /// `2^n - 1` is minimum moves * 3 seconds per move
  static int calculateTimeLimit(int diskCount) => ((1 << diskCount) - 1) * 3;
}
