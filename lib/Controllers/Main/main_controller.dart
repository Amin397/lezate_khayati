import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;

  late PageController pageController;

  void changePage(int i) {
    currentIndex(i);
  }

  @override
  void onInit() {
    pageController = PageController(
      initialPage: currentIndex.value,
    );
    super.onInit();
  }
}
