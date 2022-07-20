import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

import '../../Controllers/Music/music_controller.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/color_utils.dart';
import 'Widget/build_music_item.dart';

class MusicScreen extends StatelessWidget {
  final MusicController controller = Get.put(MusicController());

  MusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      // color: Color(0xffE5E5E5),
      color: Colors.grey[200],
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .04,
          ),
          _buildSearchBox(),
          SizedBox(
            height: Get.height * .015,
          ),
          _buildMusicList()
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: -3,
        lightSource: LightSource.topLeft,
        color: Colors.grey[100],
      ),
      margin: paddingSymmetricH8,
      child: Container(
        width: Get.width,
        height: Get.height * .05,
        padding: paddingAll4,
        child: TextField(
          controller: controller.searchTextController,
          textAlign: TextAlign.start,
          maxLines: 1,
          cursorColor: Colors.black,
          style: TextStyle(
            color: ColorUtils.textColor,
            fontSize: 15.0,
          ),
          decoration: InputDecoration(
            hintText: 'جستجو',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
          textAlignVertical: TextAlignVertical.bottom,
        ),
      ),
    );
  }

  Widget _buildMusicList() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.musicList.length,
          itemBuilder: (BuildContext context, int index) => BuildMusicItem(
            item: controller.musicList[index],
            index: index,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
