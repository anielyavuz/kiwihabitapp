import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';

class FirebaseDocs {
  final player = AudioPlayer();
  playAudio(String url) async {
    // Create a player
    final duration = await player.setUrl(// Load a URL
        url); // Schemes: (https: | file: | asset: )
    player.play();
  }
}
