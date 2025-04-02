import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isMuted = false;
  static double _volume = 1.0;

  static bool get isMuted => _isMuted;
  static double get volume => _volume;

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _volume = prefs.getDouble('volume') ?? 1.0;
    _isMuted = prefs.getBool('isMuted') ?? false;
    _audioPlayer.setVolume(_isMuted ? 0 : _volume);
  }

  static Future<void> play(String path) async {
    if (_isMuted) return;

    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(path), volume: _volume);
  }

  static Future<void> setVolume(double newVolume) async {
    _volume = newVolume;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', newVolume);

    if (!_isMuted) {
      await _audioPlayer.setVolume(_volume);
    }
  }

  static Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMuted', _isMuted);

    _audioPlayer.setVolume(_isMuted ? 0 : _volume);
  }
}
