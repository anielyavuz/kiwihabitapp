import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class PlayAudio {
  Soundpool pool = Soundpool(streamType: StreamType.music);

  play(String command) async {
    int soundId;
    if (command == "Check") {
      soundId = await rootBundle
          .load("assets/audio/correct.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    } else {
      soundId = await rootBundle
          .load("assets/audio/wrong2.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }
    print("Test");
    int streamId = await pool.play(soundId);
  }
}
