// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {

  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;

  MusicPlayer({this.songInfo, this.changeTrack, this.key}):super(key: key);

  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {

  double minimumValue = 0.0 ,maximumValue = 0.0 ,currentValue = 0.0;
  String currentTime = '' ,endTime = '';
  bool isPlaying = false;

  final AudioPlayer player = AudioPlayer();

  void initState() {

    super.initState();

    setSong(widget.songInfo);
  }

  void dispose() {

    super.dispose();

    player?.dispose();
    autoChange();
  }

  void autoChange() {

    if(currentValue >= maximumValue) {

      widget.changeTrack(true);
    }
  }

  void setSong(SongInfo songInfo) async {

    widget.songInfo = songInfo;

    await player.setUrl(widget.songInfo.uri);

    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();

    setState(() {

      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });

    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {

      currentValue = duration.inMilliseconds.toDouble();
      setState(() {

        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {

    setState(() {
      isPlaying =! isPlaying;
    });

    if(isPlaying){
      player.play();
    }
    else {
      player.pause();
    }
  }

  String getDuration(double value) {

    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds].map((element)=>element.remainder(60).toString().padLeft(2,'0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.white,leading: IconButton(icon: const Icon(Icons.arrow_back_ios_sharp,color: Colors.black,), onPressed: () {

        Navigator.of(context).pop();
      },),title: const Text('Now Playing', style: TextStyle(color: Colors.black),),),

      body: Container(

        margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),

        child: Column(children: <Widget>[

          CircleAvatar(backgroundImage: widget.songInfo.albumArtwork==null?const AssetImage('assets/music_default.jpg'):FileImage(File(widget.songInfo.albumArtwork)),radius: 95,),

          Container(margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(widget.songInfo.title, style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),),
          ),

          Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(widget.songInfo.artist, style: const TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500),),
          ),

          Slider(inactiveColor: Colors.black12, activeColor: Colors.black,min: minimumValue, max: maximumValue, value: currentValue, onChanged: (value) {

            currentValue = value;
            player.seek(Duration(milliseconds: currentValue.round()));

          },),

          Container(transform: Matrix4.translationValues(0, -5, 0), margin: const EdgeInsets.fromLTRB(5, 0, 5, 15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

            Text(currentTime, style: const TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500),),
            Text(endTime, style: const TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500),),
          ],),),

          Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [

            GestureDetector(child: const Icon(Icons.skip_previous, color: Colors.black, size: 55,),behavior: HitTestBehavior.translucent, onTap: () {

              widget.changeTrack(false);
            },),

            GestureDetector(child: Icon(isPlaying?Icons.pause_circle_filled_rounded:Icons.play_circle_fill_rounded, color: Colors.black, size: 75,),behavior: HitTestBehavior.translucent, onTap: () {

              changeStatus();
            },),

            GestureDetector(child: const Icon(Icons.skip_next, color: Colors.black, size: 55,),behavior: HitTestBehavior.translucent, onTap: () {

              widget.changeTrack(true);
            },),
          ],),)
        ],),
      ),
    );
  }
}


