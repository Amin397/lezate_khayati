import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Models/Music/music_model.dart';
import '../../Utils/Api/project_request_utils.dart';

class MusicController extends GetxController with SingleGetTickerProviderMixin {
  TextEditingController searchTextController = TextEditingController();

  RequestsUtil request = RequestsUtil();

  RxBool isLoaded = false.obs;

  AudioPlayer player = AudioPlayer();

  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  List<MusicModel> musicList = [];

  @override
  void onInit() {
    getMusics();
    super.onInit();
  }

  void getMusics() async {
    ApiResult result = await request.getMusics();
    if (result.isDone) {
      musicList = MusicModel.listFromJson(result.data);
      // musicList.forEach((element) {
      //   element.audioPlayer!.onPlayerStateChanged.listen((event) {
      //     element.isPlayed!(event == PlayerState.playing);
      //     update(['audio']);
      //   });
      //
      //   element.audioPlayer
      //   !.onDurationChanged.listen((event) {
      //     element.totalDuration = event;
      //     update(['audio']);
      //   });
      //
      //
      //   element.audioPlayer
      //   !.onPositionChanged.listen((event) {
      //     element.position = event;
      //     update(['audio']);
      //   });
      //
      // });
      isLoaded(true);
    }
  }

  void playOrPause({required MusicModel item}) async {
    musicList.forEach((element) {
      if (item != element) {
        element.isLoading!(false);
        element.isPlayed!(false);
        element.audioPlayer!.dispose();
      }
    });

    print(item.isPlayed!.value);

    if (item.isPlayed!.isTrue) {
      await item.audioPlayer!.pause();
      item.isPlayed!(false);
    } else {
      item.isLoading!(true);
      await item.audioPlayer!
          .play(UrlSource(item.url!.replaceAll('http', 'https')));

      item.audioPlayer!.onPlayerStateChanged.listen((event) {
        item.isPlayed!(event == PlayerState.playing);
        update(['audio']);
      });

      item.audioPlayer!.onDurationChanged.listen((event) {
        item.isLoading!(false);
        item.isPlayed!(true);
        item.totalDuration = event;

        update(['audio']);
      });

      item.audioPlayer!.onPositionChanged.listen((event) {
        item.position = event;

        update(['audio']);
      });

      item.audioPlayer!.onPlayerComplete.listen((event) {
        item.isPlayed!(false);
        int index = musicList.indexOf(item);
        if (index != musicList.length) {
          playOrPause(item: musicList[index + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    musicList.forEach((element) {
      element.audioPlayer!.dispose();
    });
    super.dispose();
  }

  void seekMusic({required double newPosition, required MusicModel item}) {
    item.audioPlayer!.seek(
      Duration(
        milliseconds: newPosition.toInt(),
      ),
    );

    item.position = Duration(milliseconds: newPosition.toInt());
    update(['audio']);
  }

  void searchItem({required String text}) {
    if (text.isEmpty) {
      musicList.forEach((element) {
        element.isShow!(true);
      });
    } else {
      musicList.forEach((element) {
        if (!element.name!.contains(text)) {
          element.isShow!(false);
        } else {
          element.isShow!(true);
        }
      });
    }
  }
}
