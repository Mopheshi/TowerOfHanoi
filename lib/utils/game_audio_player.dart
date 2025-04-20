import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../utils/utils.dart';

class GameAudioPlayer {
  static final AudioPlayer _musicPlayer = AudioPlayer();
  static final Map<GameSounds, AudioPlayer> _soundPlayers = {};

  static bool _initialized = false;

  static final Map<GameSounds, String> _soundPaths = {
    GameSounds.select: selectSound,
    GameSounds.deselect: deselectSound,
    GameSounds.move: moveSound,
    GameSounds.error: errorSound,
    GameSounds.win: winSound,
    GameSounds.reset: resetSound,
    GameSounds.click: clickSound,
    GameSounds.lost: lostSound,
  };

  /// Preload all sounds during initialization
  static Future<void> initialize() async {
    if (_initialized) return;
    ll("Starting audio initialization");

    try {
      // Configure audio session for mixing
      ll("Configuring audio session");
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      ll("Audio session configured");

      // Create audio players for each sound
      ll("Creating sound players");
      await Future.wait(
        _soundPaths.entries.map((entry) async {
          ll("Creating player for: ${entry.key}");
          _soundPlayers[entry.key] =
              AudioPlayer()
                ..setAsset(entry.value)
                ..setVolume(1.0);
          ll("Created player for: ${entry.key}");
        }),
      );

      _initialized = true;
      ll("Audio initialization complete");
    } catch (e) {
      ll("Audio initialization failed: $e");
      _initialized = true; // Mark as initialized to avoid retries
    }
  }

  /// Play background music
  static Future<void> playBackgroundMusic() async {
    try {
      ll("Loading background music: $backgroundMusic");
      await _musicPlayer.setAsset(backgroundMusic);
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.play();
      ll("Background music started");
    } catch (e, stackTrace) {
      ll("Failed to play background music: $e");
      ll("Stack trace: $stackTrace");
    }
  }

  /// Play a sound effect
  static void playEffect(GameSounds sound) {
    try {
      final player = _soundPlayers[sound];
      player?.seek(Duration.zero).then((_) => player.play());
      ll("Playing sound: $sound");
    } catch (e) {
      ll("Failed to play sound effect: $e");
    }
  }

  /// Pause music
  static Future<void> pauseBackgroundMusic() async {
    await _musicPlayer.pause();
    ll("Background music paused");
  }

  /// Stop music
  static Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
    ll("Background music stopped");
  }

  static Future<void> dispose() async {
    await _musicPlayer.dispose();
    await Future.wait(_soundPlayers.values.map((player) => player.dispose()));
    _soundPlayers.clear();
    _initialized = false;
    ll("Audio disposed");
  }
}
