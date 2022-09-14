import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lezate_khayati/Models/SinglePriceyCourse/single_pricey_course_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Views/SinglePriceyCourse/Widgets/build_bought_video_alert.dart';
import '../../Views/SinglePriceyCourse/Widgets/build_more_videos_modal.dart';
import '../../Views/SinglePriceyCourse/Widgets/build_show_video_modal.dart';
import '../../Views/SinglePriceyCourse/Widgets/show_justify_alert.dart';
import '../../Views/SinglePriceyCourse/Widgets/show_set_rate_modal.dart';

class SinglePriceyCourseController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;
  late final bool free;

  late final SinglePriceyCourseModel model;

  RxBool isLoaded = false.obs;
  double rate = 0.0;

  @override
  void onInit() {
    index = Get.arguments['index'];
    id = Get.arguments['id'];
    image = Get.arguments['image'];
    name = Get.arguments['name'];
    free = Get.arguments['free'];

    getData();
    super.onInit();
  }

  Future<File> getThumb({required String url}) async {
    var amin = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    print(amin);
    return File(amin!);
  }

  void getData() async {
    ApiResult result = await RequestsUtil.instance.singlePriceyCourse(
      id: id.toString(),
      // id: '18',
    );
    if (result.isDone) {
      model = SinglePriceyCourseModel.fromJson(result.data);

      if (model.videos!.isNotEmpty) {
        model.videos!.forEach((element) async {
          element.thumb = await getThumb(
            url: element.url!,
          );
          update(['videoThumb']);
          isLoaded(true);
        });
      } else {
        update(['videoThumb']);
        isLoaded(true);
      }
    }
  }

  void openVideo({required Video video, required bool demo}) async {
    EasyLoading.show();
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    await video.videoController.initialize();

    video.chewieController = ChewieController(
      videoPlayerController: video.videoController,
      autoPlay: true,
    );

    EasyLoading.dismiss();
    final s = await showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          BuildShowVideoModal(controller: this, video: video),
    );

    video.videoController.pause();
    video.chewieController!.pause();
  }

  void showBoughtAlert({required Video video}) async {
    bool buy = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: BuildBoughtVideoAlert(),
      ),
    );

    if (buy) {
      buyCourse();
    }
  }

  void buyCourse() async {
    EasyLoading.show();
    ApiResult result =
        await RequestsUtil.instance.buyCourse(courseId: model.id.toString());
    EasyLoading.dismiss();
    if (result.status == 200) {}
  }

  void showMoreVideos() async {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
      builder: (BuildContext context) => BuildMoreVideosModal(
        controller: this,
      ),
    );
  }

  void showJustifiedAlert() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: ShowJustifyAlert(),
      ),
    );
  }

  void switchBookmark() async {
    if (model.isBookmarked.isTrue) {
      EasyLoading.show();
      ApiResult result = await RequestsUtil.instance.setBookmark(
        id: model.id.toString(),
        type: 'course',
      );
      EasyLoading.dismiss();
      if(result.isDone){
        Future.delayed(Duration(milliseconds: 200) , (){
          model.isBookmarked(false);
        });
      }
    } else {
      // var setStar = await showModalBottomSheet(
      //   context: Get.context!,
      //   backgroundColor: Colors.transparent,
      //   isDismissible: false,
      //   enableDrag: false,
      //   builder: (BuildContext context) => ShowSetRateModal(
      //     rate: double.parse(model.reviewsRating.toString()),
      //   ),
      // );

      // if (setStar is double) {
        EasyLoading.show();
        ApiResult result = await RequestsUtil.instance.setBookmark(
          id: model.id.toString(),
          type: 'course',
        );
        EasyLoading.dismiss();
        if(result.isDone){
          Future.delayed(Duration(milliseconds: 200) , (){
            model.isBookmarked(true);
          });
        }
      // }
    }
  }
}
