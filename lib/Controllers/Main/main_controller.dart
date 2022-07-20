import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

class MainController extends GetxController {
  RxInt currentIndex = 2.obs;

  late PageController pageController;

  void changePage(int i) {
    currentIndex(i);
    pageController.animateToPage(
      currentIndex.value,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  void onInit() {
    pageController = PageController(
      initialPage: currentIndex.value,
    );
    super.onInit();
  }



}
