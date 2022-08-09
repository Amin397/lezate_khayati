import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Models/SinglePriceyCourse/single_pricey_course_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Views/SinglePriceyCourse/Widgets/build_bought_video_alert.dart';

class SinglePriceyCourseController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;

  late final SinglePriceyCourseModel model;

  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    index = Get.arguments['index'];
    id = Get.arguments['id'];
    image = Get.arguments['image'];
    name = Get.arguments['name'];

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
      // id: id.toString(),
      id: '18',
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
      }
      // Future.delayed(Duration(seconds: 1) , (){
      //
      // });
    }
  }

  void openVideo({required Video video}) async {}

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

    EasyLoading.show();
    if(buy){

      buyCourse();
    }
  }

  void buyCourse() async{
    ApiResult result = await RequestsUtil.instance.buyCourse(courseId:model.id.toString());
    EasyLoading.dismiss();
    if(result.status == 200){

    }
  }
}
