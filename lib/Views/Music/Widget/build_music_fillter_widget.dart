import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Plugins/neu/src/widget/container.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

import '../../../Controllers/Music/music_controller.dart';

class BuildMusicFilterWidget extends StatelessWidget {
  const BuildMusicFilterWidget({Key? key, required this.controller})
      : super(key: key);
  final MusicController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Neumorphic(
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
        margin: paddingSymmetricH8,
        child: Container(
          width: Get.width * .4,
          height: Get.height * .05,
          decoration: BoxDecoration(
            borderRadius: radiusAll8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.filter_list_rounded ,),
              Text('فیلتر بر اساس')
            ],
          ),
        ),
      ),
    );
  }
}
