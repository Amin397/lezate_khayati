import 'package:auto_size_text/auto_size_text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

import '../../../Controllers/SinglePriceyCourse/single_pricey_course_controller.dart';
import '../../../Models/SinglePriceyCourse/single_pricey_course_model.dart';
import '../../../Plugins/get/get.dart';

class BuildShowVideoModal extends StatelessWidget {
  const BuildShowVideoModal({
    Key? key,
    required this.controller,
    required this.video,
  }) : super(key: key);

  final SinglePriceyCourseController controller;
  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .97,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Center(
                child: Chewie(
                  controller: video.chewieController!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: Get.width,
      height: Get.height * .05,
      padding: paddingSymmetricH8,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 5.0,
            spreadRadius: 3.0,
            offset: Offset(0.0, 3.0),
          )
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
            ),
          ),
          AutoSizeText(
            video.name!,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
