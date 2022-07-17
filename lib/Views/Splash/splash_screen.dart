import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Splash/splash_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(
    SplashController(),
  );
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.black,
      body: Center(
        child: Image.asset('assets/img/logo.png'),
      ),
    );
  }
}
