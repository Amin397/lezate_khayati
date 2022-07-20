import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Music/music_controller.dart';
import 'package:lezate_khayati/Models/Music/music_model.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:music_visualizer/music_visualizer.dart';

import '../../../Plugins/get/get.dart';
import '../../../Plugins/neu/flutter_neumorphic.dart';
import '../../../Utils/Consts.dart';

class BuildMusicItem extends StatelessWidget {
  const BuildMusicItem(
      {Key? key,
      required this.item,
      required this.index,
      required this.controller})
      : super(key: key);

  final MusicController controller;
  final MusicModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          depth: 5,
          lightSource: LightSource.topLeft,
          // color: Color(0xffEEEFF4),
          color: Colors.grey[100],
          shadowLightColorEmboss: Colors.red,
          shadowLightColor: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: Get.width * .03, vertical: 8.0),
      child: Container(
        height: Get.height * .11,
        width: Get.width,
        child: Row(
          children: [
            SizedBox(
              width: Get.width * .1,
              height: double.maxFinite,
              child: Obx(
                () => IconButton(
                  onPressed: () {
                    controller.playOrPause(item: item);
                  },
                  icon: (item.isPlayed.isTrue)
                      ? Icon(Icons.pause)
                      : Icon(
                          Icons.play_arrow,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: paddingAll4,
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Obx(
                          () => (item.isPlayed.isTrue)
                              ? MusicVisualizer(
                                  barCount: 30,
                                  colors: controller.colors,
                                  duration: controller.duration,
                                )
                              : SizedBox(),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Slider(
                          activeColor: const Color(0xfff00d9be),
                          value: controller.position.inMilliseconds.toDouble(),
                          min: 0,
                          max: controller.totalDuration.inMilliseconds
                                  .toDouble() +
                              10,
                          onChanged: (value) {
                            controller.audioPlayer
                                .seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                            item.name,
                            maxLines: 2,
                            maxFontSize: 16.0,
                            minFontSize: 12.0,
                            style: TextStyle(
                              color: ColorUtils.textColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
