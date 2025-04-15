import 'package:audioplayers/audioplayers.dart';

import 'utils.dart';

class GameAudioPlayer {
  static final AudioPlayer _effectPlayer = AudioPlayer();
  static final AudioPlayer _musicPlayer = AudioPlayer();
  static final AudioCache _audioCache = AudioCache(
    prefix: assetsPath + soundsPath,
  );

  static final Map<GameSounds, String> _sounds = {
    GameSounds.select: 'select.mp3',
    GameSounds.deselect: 'deselect.mp3',
    GameSounds.move: 'move.mp3',
    GameSounds.error: 'error.mp3',
    GameSounds.win: 'win.mp3',
    GameSounds.clap: 'clap.mp3',
    GameSounds.reset: 'reset.mp3',
    GameSounds.click: 'click.mp3',
  };

  static bool _initialized = false;

  /// Initializes the audio players and preloads sound files.
  ///
  /// This method prepares the audio system by setting up players for sound effects
  /// and background music. It preloads all required sound files to ensure smooth
  /// playback during gameplay.
  ///
  /// **Returns:**
  /// - A [Future] that completes when initialization is done.
  ///
  /// **Side Effects:**
  /// - Initializes audio players and caches sound files.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Preload all sound files
      await _audioCache.loadAll(_sounds.values.toList());

      // Configure audio players
      await _effectPlayer.setVolume(0.7);
      await _musicPlayer.setVolume(0.4);
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      // Set global audio context to allow mixing
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
        ),
      );

      _initialized = true;
      ll('Audio initialized with ${_sounds.length} sounds preloaded');
    } catch (e) {
      ll('Audio initialization failed: $e');
    }
  }

  /// Plays a specified sound effect.
  ///
  /// This method triggers the playback of a sound effect based on the provided
  /// [sound] enum value. It leverages the preloaded audio cache for quick and
  /// efficient playback.
  ///
  /// **Parameters:**
  /// - [sound]: The [GameSounds] enum value representing the sound to play.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the sound starts playing.
  static Future<void> playEffect(GameSounds sound) async {
    if (!_initialized) return;

    final fileName = _sounds[sound];
    if (fileName == null) {
      ll('Sound $sound not found');
      return;
    }

    try {
      final uri = await _audioCache.load(fileName);
      // await _effectPlayer.stop(); // Optional
      await _effectPlayer.play(UrlSource(uri.path));
      ll('Playing sound: $fileName');
    } catch (e) {
      ll('Error playing $sound: $e');
    }
  }

  /// Starts playing the background music in a loop.
  ///
  /// This method begins playback of the background music if it is not already
  /// playing, ensuring a continuous audio experience. The music loops indefinitely
  /// until stopped.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the music starts playing.
  ///
  /// **Side Effects:**
  /// - Starts the background music player in looping mode.
  static Future<void> playBackgroundMusic() async {
    if (!_initialized) return;

    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      // Only start if not already playing
      if (_musicPlayer.state != PlayerState.playing) {
        final uri = await _audioCache.load(backgroundMusic.split('/').last);
        await _musicPlayer.play(UrlSource(uri.path));
        ll('Background music started');
      }
    } catch (e) {
      ll('Error starting music: $e');
    }
  }

  static Future<void> stopBackgroundMusic() async {
    if (!_initialized) return;

    try {
      await _musicPlayer.stop();
      ll('Background music stopped');
    } catch (e) {
      ll('Error stopping background music: $e');
    }
  }

  static Future<void> dispose() async {
    await _effectPlayer.dispose();
    await _musicPlayer.dispose();
    _initialized = false;
  }
}
