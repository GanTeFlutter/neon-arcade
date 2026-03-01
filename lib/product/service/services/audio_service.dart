import 'package:akillisletme/product/service/service_locator.dart';
import 'package:audioplayers/audioplayers.dart';

/// Neon Arcade sound effects service.
/// Plays short SFX files. No background music.
class AudioService {
  AudioService._internal();
  static final AudioService instance = AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  bool get _enabled => locator.sharedCache.isSoundEnabled;

  Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _play(String assetPath) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } on Exception catch (_) {
      // Silently continue if the sound file cannot be loaded.
    }
  }

  /// Touch / tap sound
  Future<void> playBlip() => _play('songs/blip.mp3');

  /// Success / score sound (ascending arpeggio)
  Future<void> playSynth() => _play('songs/synth_arpeggio.mp3');

  /// Error / death sound (low tone)
  Future<void> playBuzz() => _play('songs/buzz.mp3');

  /// Combo / special achievement sound
  Future<void> playChime() => _play('songs/chime.mp3');

  /// Perfect alignment sound
  Future<void> playPerfect() => _play('songs/perfect.mp3');

  void dispose() {
    _player.dispose();
  }
}
