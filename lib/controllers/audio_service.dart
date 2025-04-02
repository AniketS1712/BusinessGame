import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool isMuted = false;
  static double volume = 1.0;

  static Future<void> play(String path) async {
    if (isMuted) {
      return;
    }

    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(path), volume: volume);
  }

  static Future<void> setVolume(double newVolume) async {
    volume = newVolume;
    if (!isMuted) {
      await _audioPlayer.setVolume(volume);
    }
  }

  static void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      _audioPlayer.stop();
    } else {
      _audioPlayer.setVolume(volume);
    }
  }
}
