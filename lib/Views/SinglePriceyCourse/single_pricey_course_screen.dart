import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Models/SinglePriceyCourse/single_pricey_course_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/SinglePriceyCourse/single_pricey_course_controller.dart';

class SinglePriceyCourseScreen extends StatelessWidget {
  SinglePriceyCourseScreen({Key? key}) : super(key: key);

  final SinglePriceyCourseController controller =
      Get.put(SinglePriceyCourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.name,
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          Obx(()=>(controller.isLoaded.isTrue)?_buildBookmarkIcon():Container())
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.grey[200],
        child: Column(
          children: [
            _buildImage(),
            Obx(
              () => (controller.isLoaded.isTrue)
                  ? Expanded(
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            _buildDescription(),
                            _buildUpdate(),
                            if (controller.model.videos!.isNotEmpty)
                              _buildVideos(),
                            if (!controller.model.isBought! && !controller.free)
                              _buildBuyButton()
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: _buildShimmer(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: Get.width,
      height: Get.height * .35,
      margin: paddingAll16,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
        boxShadow: ViewUtils.neoShadow(),
        color: Colors.white,
      ),
      child: Hero(
        tag: 'pricey-${controller.index}',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              controller.image,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: Get.width,
      height: Get.height * .07,
      margin: paddingAll16,
      child: Align(
        alignment: Alignment.topRight,
        child: AutoSizeText(
          parse(parse(controller.model.description!).body!.text)
              .documentElement!
              .text,
          maxFontSize: 16.0,
          minFontSize: 10.0,
          maxLines: 5,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdate() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: Get.width,
        height: Get.height * .04,
        margin: paddingAll16,
        child: Row(
          children: [
            SizedBox(
              height: Get.height * .03,
              width: Get.width * .35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'بروز شده در :',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .03,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          '${controller.model.update!.first}/${controller.model.update![1]}/${controller.model.update!.last}',
                          maxLines: 1,
                          maxFontSize: 18.0,
                          minFontSize: 12.0,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (!controller.free)
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        ViewUtils.moneyFormat(
                          double.parse(
                            controller.model.price!,
                          ),
                        ),
                        maxLines: 1,
                        maxFontSize: 18.0,
                        minFontSize: 14.0,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      AutoSizeText(
                        'تومان',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
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

  Widget _buildShimmer() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.2),
          highlightColor: Colors.white24,
          child: Container(
            width: Get.width,
            margin: paddingAll10,
            height: Get.height * .15,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: radiusAll12,
            ),
          ),
        ),
        // SizedBox(
        //   height: Get.height * .03,
        // ),
        SizedBox(
          height: Get.height * .15,
          width: Get.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .17,
          width: Get.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVideos() {
    return Container(
      width: Get.width,
      height: Get.height * .24,
      child: Column(
        children: [
          if (controller.model.videos!.length >= 4)
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  controller.showMoreVideos();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AutoSizeText(
                    'بیشتر',
                    style: TextStyle(fontSize: 12.0, color: Colors.blue),
                  ),
                ),
              ),
            ),
          // : SizedBox(),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: (controller.model.videos!.length > 4)
                      ? controller.model.videos!.getRange(0, 3).length
                      : controller.model.videos!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildVideoItem(
                      video: controller.model.videos![index],
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem({
    required Video video,
    required int index,
  }) {
    return GetBuilder(
      init: controller,
      id: 'videoThumb',
      builder: (ctx) => InkWell(
        onTap: () {
          if (controller.model.isBought!) {
            controller.openVideo(video: video, demo: false);
          } else {
            if (Globals.userStream.user!.justified == 1) {
              controller.openVideo(
                video: video,
                demo: true,
              );
            } else {
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
      ),
    );
  }

  Widget _buildBuyButton() {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.buyCourse();
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Get.height * .05,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: radiusAll8,
            ),
            margin: paddingAll10,
            child: Center(
              child: AutoSizeText(
                'خرید دوره',
                maxFontSize: 18.0,
                maxLines: 1,
                minFontSize: 14.0,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );
      },
      child: controller.model.isBookmarked.isTrue
          ? IconButton(
              onPressed: () {
                controller.switchBookmark();
              },
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
            )
          : IconButton(
              onPressed: () {
                controller.switchBookmark();
              },
              icon: Icon(
                Icons.bookmark_outline,
                color: Colors.white,
              ),
            ),
    );
  }
}
