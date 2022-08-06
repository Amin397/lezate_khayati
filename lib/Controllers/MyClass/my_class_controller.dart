import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/MyClass/my_courses_model.dart';

class MyClassController extends GetxController{

  List<MyCourseModel> courseList = [];
  RxBool isLoaded = false.obs;


  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async{
    ApiResult result = await RequestsUtil.instance.getUserClass();
    if(result.isDone){
      courseList = MyCourseModel.listFromJson(result.data['courses']);
      isLoaded(true);
    }
  }


  void search({required String text}) {
    if (text.isEmpty) {
      courseList.forEach((element) {
        element.visible(true);
      });
    } else {
      courseList.forEach((element) {
        if (!element.name!.contains(text)) {
          element.visible(false);
        } else {
          element.visible(true);
        }
      });
    }
  }



}