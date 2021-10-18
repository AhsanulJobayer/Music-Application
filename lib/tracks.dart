// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_corner/music_player.dart';

void main() => runApp(const MaterialApp(
  home: Tracks(),
));

class Tracks extends StatefulWidget {
  const Tracks({Key key}) : super(key: key);


  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List <SongInfo> songs = [];

  int currentIndex = 0;

  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  @override
  void initState() {

    super.initState();
    getTracks();
  }

  void getTracks() async {

    songs = await audioQuery.getSongs();

    setState(() {
      songs=songs;
    });
  }

  void changeTrack(bool isNext) {

    if(isNext) {
      if(currentIndex!= songs.length-1) {
        currentIndex++;

      }
    } else {
      if(currentIndex!= 0) {
        currentIndex--;

      }
    }

    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.white,leading: const Icon(Icons.music_note,color: Colors.black,),title: const Text('Music App', style: TextStyle(color: Colors.black),),),

      body: ListView.separated(separatorBuilder: (context,index)=>const Divider(),itemCount: songs.length,itemBuilder: (context,index)=>ListTile(leading: CircleAvatar( backgroundImage: songs[index].albumArtwork==null? const AssetImage('assets/music_default.jpg'):FileImage(File(songs[index].albumArtwork)),),title: Text(songs[index].title),subtitle: Text(songs[index].artist),onTap: () {

        currentIndex = index;
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicPlayer(songInfo: songs[currentIndex],changeTrack: changeTrack,key: key,)));
      },),),
    );
  }
}
