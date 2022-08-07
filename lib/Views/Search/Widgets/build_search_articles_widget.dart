import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Search/search_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

class BuildSearchArticlesWidget extends StatelessWidget {
  const BuildSearchArticlesWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,

    );
  }
}
