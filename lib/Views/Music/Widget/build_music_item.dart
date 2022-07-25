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
          shadowLightColor: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Get.width * .03,
          vertical: 8.0,
        ),
        child: Obx(
          () => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height:
                (item.isPlayed!.isTrue) ? Get.height * .3 : Get.height * .11,
            width: Get.width,
            child: Column(
              children: [
                (item.isPlayed!.isTrue)
                    ? Container(
                        width: Get.width,
                        height: Get.height * .2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.0),
                          ),
                          child: Image(
                            image: NetworkImage(
                              item.img!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.width * .1,
                          height: double.maxFinite,
                          child: Obx(
                            () => (item.isLoading!.isTrue)
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Get.height * .04,
                                      horizontal: 8.0,
                                    ),
                                    child: CircularProgressIndicator(),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      controller.playOrPause(item: item);
                                    },
                                    icon: (item.isPlayed!.isTrue)
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
                                      () => (item.isPlayed!.isTrue)
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
                                    child: GetBuilder(
                                      init: controller,
                                      id: 'audio',
                                      builder: (ctx) => Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Slider(
                                          activeColor: const Color(0xfff00d9be),
                                          value: item.position!.inMilliseconds
                                              .toDouble(),
                                          min: 0,
                                          max: item
                                                  .totalDuration!.inMilliseconds
                                                  .toDouble() +
                                              10,
                                          onChanged: (value) {
                                            controller.seekMusic(
                                              newPosition: value,
                                              item: item,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: GetBuilder(
                                      init: controller,
                                      id: 'audio',
                                      builder: (ctx) => Container(
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: SizedBox(
                                                child: AutoSizeText(
                                                  item.name!,
                                                  maxLines: 2,
                                                  maxFontSize: 16.0,
                                                  minFontSize: 12.0,
                                                  style: TextStyle(
                                                    color: ColorUtils.textColor,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                height: double.maxFinite,
                                                width: double.maxFinite,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: SizedBox(
                                                height: double.maxFinite,
                                                width: double.maxFinite,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    AutoSizeText(
                                                      // item.totalDuration!.inMinutes.toString() + ':' + item.totalDuration!.inSeconds.toString(),
                                                      getTimeString(
                                                          item.position!),
                                                      maxLines: 1,
                                                      maxFontSize: 14.0,
                                                      minFontSize: 8.0,
                                                      style: TextStyle(
                                                        color: ColorUtils
                                                            .textColor,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                    Text(' / '),
                                                    AutoSizeText(
                                                      // item.position!.inMinutes.toString() + ':' + item.position!.inSeconds.toString(),
                                                      getTimeString(
                                                          item.totalDuration!),
                                                      maxLines: 1,
                                                      maxFontSize: 14.0,
                                                      minFontSize: 8.0,
                                                      style: TextStyle(
                                                        color: ColorUtils
                                                            .textColor,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
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
        ));
  }

  String getTimeString(Duration time) {
    final int hour = time.inSeconds ~/ 60;
    final int minutes = time.inSeconds % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }
}
