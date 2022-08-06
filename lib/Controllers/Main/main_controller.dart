import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Chat/chat_controller.dart';
import 'package:lezate_khayati/Controllers/Home/home_controller.dart';
import 'package:lezate_khayati/Controllers/Profile/profile_controller.dart';
import 'package:lezate_khayati/Controllers/Training/training_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../Music/music_controller.dart';

class MainController extends GetxController {
  RxInt currentIndex = 2.obs;

  late PageController pageController;

  void changePage(int i) {
    currentIndex(i);
    pageController.jumpToPage(
      currentIndex.value,
      // duration: Duration(milliseconds: 300),
      // curve: Curves.easeIn,
    );
    print(i);
    switch(i){
      case 0:{

        Get.delete<ChatController>();
        Get.delete<HomeController>();
        Get.delete<ProfileController>();
        break;
      }
      case 1:{
        Get.delete<MusicController>();
        Get.delete<HomeController>();
        Get.delete<ProfileController>();
        // Get.delete<ChatController>();
        break;
      }
      case 2:{
        Get.delete<ChatController>();
        Get.delete<MusicController>();
        // Get.delete<TrainingController>();
        Get.delete<ProfileController>();
        break;
      }
      case 3:{
        Get.delete<MusicController>();
        Get.delete<ChatController>();
        Get.delete<HomeController>();
        // Get.delete<TrainingController>();
        break;
      }
      // case 4:{
      //   Get.delete<MusicController>();
      //   Get.delete<ChatController>();
      //   Get.delete<TrainingController>();
      //   // Get.delete<ProfileController>();
      //   break;
      // }
    }
  }

  @override
  void onInit() {
    pageController = PageController(
      initialPage: currentIndex.value,
    );
    super.onInit();
  }
}
