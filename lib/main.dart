// @dart=2.9
import 'package:flutter/material.dart';
import 'package:music_corner/tracks.dart';

void main() => runApp(const MaterialApp(
      home: audio_player(),
    ));

class audio_player extends StatelessWidget {
  const audio_player({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Run'),),
    );
  }
}

