
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../Models/Music/music_model.dart';


class MusicController extends GetxController with SingleGetTickerProviderMixin{
  TextEditingController searchTextController = TextEditingController();





  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];


  bool isPlay = false;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration totalDuration = Duration.zero;
  Duration position = Duration.zero;

  // String? myUrl;


  List<MusicModel> musicList = [
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
    MusicModel(name: 'amin' , isPlayed: false.obs),
  ];

  void playOrPause({required MusicModel item}) {
    item.isPlayed(!item.isPlayed.value);
  }



  @override
  void onInit() {
    super.onInit();
  }




}