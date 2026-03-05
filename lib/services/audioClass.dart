import 'package:just_audio/just_audio.dart';

class PlayAudio {
  Future<void> play(String command) async {
    final player = AudioPlayer();
    final Map<String, String> sounds = {
      "tik": "assets/audio/tik.mp3",
      "popUp": "assets/audio/popUp.mp3",
      "check": "assets/audio/check.mp3",
      "uncheck": "assets/audio/uncheck.mp3",
      "baloncuk": "assets/audio/baloncuk.mp3",
    };
    final path = sounds[command] ?? sounds["popUp"]!;
    await player.setAsset(path);
    await player.play();
    player.dispose();
  }
}
