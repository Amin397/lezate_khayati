import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/Training/training_controller.dart';
import '../../Plugins/neu/flutter_neumorphic.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import 'Widget/build_training_widget.dart';

class TrainingScreen extends StatelessWidget {
  TrainingScreen({Key? key}) : super(key: key);

  final TrainingController controller = Get.put(TrainingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .04,
          ),
          _buildSearchBox(),
          SizedBox(
            height: Get.height * .04,
          ),
          BuildTrainingWidget(
            controller: controller,
          ),
          SizedBox(
            height: Get.height * .01,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
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
            suffixIcon: Icon(Icons.search),
            hintText: 'جستجو',
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
          ),
          textAlignVertical: TextAlignVertical.bottom,
        ),
      ),
    );
  }
}
