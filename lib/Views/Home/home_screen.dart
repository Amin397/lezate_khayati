import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.green,
    );
  }
}
