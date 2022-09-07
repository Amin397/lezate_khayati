import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/SinglePriceyCourse/single_pricey_course_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../Controllers/SinglePriceyCourse/single_pricey_course_controller.dart';
import '../../../Globals/Globals.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildMoreVideosModal extends StatelessWidget {
  const BuildMoreVideosModal({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SinglePriceyCourseController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: ((Get.width / 2) / (Get.height * .15) / 2),
                ),
                shrinkWrap: true,
                itemBuilder: (_, index) => _buildVideoItem(
                  index: index,
                  video: controller.model.videos![index],
                ),
                // itemCount: controller.showMoreItem!.length,
                itemCount: controller.model.videos!.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVideoItem({
    required Video video,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        if (controller.model.isBought!) {
          controller.openVideo(
              video: video,
              demo: false
          );
        } else {
          if(Globals.userStream.user!.justified == 1){
            controller.openVideo(
              video: video,
              demo: true,
            );
          }else{
            controller.showJustifiedAlert();
          }
        }
      },
      child: Container(
        height: Get.width * .2,
        width: Get.width * .34,
        margin: paddingAll16,
        decoration: BoxDecoration(
          borderRadius: radiusAll10,
          boxShadow: ViewUtils.neoShadow(),
        ),
        child: Stack(
          children: [
            (video.thumb is File)
                ? Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: ClipRRect(
                      borderRadius: radiusAll10,
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        image: FileImage(
                          video.thumb!,
                        ),
                        placeholder: AssetImage(
                          'assets/img/placeHolder.jpg',
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: const CircularProgressIndicator(),
                  ),
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: radiusAll10,
                color: Colors.black38,
              ),
            ),
            (video.thumb is File)
                ? Center(
                    child: (controller.model.isBought!)
                        ? Icon(
                            Icons.play_circle,
                            color: Colors.white60,
                            size: 30.0,
                          )
                        : Icon(
                            Icons.lock_outline,
                            color: Colors.white60,
                            size: 30.0,
                          ),
                  )
                : SizedBox(),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.height * .05,
                width: Get.width * .3,
                child: Center(
                  child: AutoSizeText(
                    video.name!,
                    maxLines: 2,
                    maxFontSize: 16.0,
                    minFontSize: 10.0,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
