import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';

import '../../Utils/storage_utils.dart';
import '../../Views/Profile/Widget/build_exit_alert.dart';

class ProfileController extends GetxController {
  void goToMyClass() {
    Get.toNamed(RoutingUtils.myClass.name);
  }

  void goToMyOrders() {
    Get.toNamed(RoutingUtils.myOrder.name);
  }

  void myQuestions() {
    Get.toNamed(RoutingUtils.myQuestion.name);
  }

  void goToMyFavorite() {
    Get.toNamed(RoutingUtils.myFavorite.name);
  }

  void goToEditProfile() {
    Get.toNamed(RoutingUtils.editProfile.name);
  }

  void exit() async {
    bool exit = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: BuildExitAlert(),
      ),
    );
    if(exit){
      StorageUtils.clearToken();
      Get.offAndToNamed(RoutingUtils.splash.name);
    }
  }
}
