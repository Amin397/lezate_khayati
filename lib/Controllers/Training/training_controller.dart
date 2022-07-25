import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';

class TrainingController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  void goToPage({
    required int id,
  }) {
    switch (id) {
      case 0:
        {
          Get.toNamed(RoutingUtils.classes.name);
          break;
        }
      case 1:
        {
          Get.toNamed(RoutingUtils.freeTraining.name);
          break;
        }
      case 2:
        {
          Get.toNamed(RoutingUtils.books.name);
          break;
        }
      case 3:
        {
          Get.toNamed(RoutingUtils.publicTraining.name);
          break;
        }
    }
  }
}
