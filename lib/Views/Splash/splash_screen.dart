import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Splash/splash_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Utils/color_utils.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(
    SplashController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/logo.png'),
            Lottie.asset(
              'assets/animations/loading.json',
              height: Get.height * .1,
              width: Get.height * .1,
            )
          ],
        ),
      ),
    );
  }
}
