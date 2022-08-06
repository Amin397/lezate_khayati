import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Views/Main/main_screen.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';

import 'Plugins/get/get.dart';

void main() async {
  await GetStorage.init();
  RequestsUtil.token = 'test';
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ColorUtils.yellow,
        ),
        textTheme: const TextTheme(
          subtitle1: TextStyle(color: Colors.white),
        ),
        fontFamily: 'iranSans',
        canvasColor: Colors.white,
        primarySwatch: ColorUtils.blue,
      ),
      getPages: [
        RoutingUtils.splash,
        RoutingUtils.login,
        RoutingUtils.main,
        RoutingUtils.books,
        RoutingUtils.classes,
        RoutingUtils.publicTraining,
        RoutingUtils.freeTraining,
        RoutingUtils.mainMore,
        RoutingUtils.singlePriceyCourse,
        RoutingUtils.singleProduct,
        RoutingUtils.singleBook,
        RoutingUtils.myClass,
        RoutingUtils.myOrder,
        // RoutingUtils.myQuestion,
        // RoutingUtils.myFavorite,
        RoutingUtils.editProfile,
      ],
      builder: EasyLoading.init(),
      home: SplashScreen(),
    ),
  );
}
