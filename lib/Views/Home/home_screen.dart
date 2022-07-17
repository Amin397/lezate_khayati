import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);


  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
