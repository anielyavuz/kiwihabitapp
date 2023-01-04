import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class PlayAudio {
  Soundpool pool = Soundpool(streamType: StreamType.music);

  play(String command) async {
    int soundId;
    if (command == "tik") {
      soundId = await rootBundle
          .load("assets/audio/tik.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else if (command == "popUp") {
      soundId = await rootBundle
          .load("assets/audio/popUp.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else if (command == "check") {
      soundId = await rootBundle
          .load("assets/audio/check.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else if (command == "uncheck") {
      soundId = await rootBundle
          .load("assets/audio/uncheck.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else if (command == "baloncuk") {
      soundId = await rootBundle
          .load("assets/audio/baloncuk.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else {
      soundId = await rootBundle
          .load("assets/audio/popUp.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }

    print("Test");
    int streamId = await pool.play(soundId);
  }
}
