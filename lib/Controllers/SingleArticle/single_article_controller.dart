import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/SingleArticle/single_article_model.dart';

class SingleArticleController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;
  late final bool free;




  late final SingleArticleModel model;

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

  void getData() async {
    ApiResult result = await RequestsUtil.instance.getSingleArticle(
      articleId: id.toString(),
    );

    if(result.isDone){
      model = SingleArticleModel.fromJson(result.data);
      isLoaded(true);
    }

  }
}
