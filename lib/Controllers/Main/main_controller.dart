import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Chat/chat_controller.dart';
import 'package:lezate_khayati/Controllers/Home/home_controller.dart';
import 'package:lezate_khayati/Controllers/Login/login_controller.dart';
import 'package:lezate_khayati/Controllers/Profile/profile_controller.dart';
import 'package:lezate_khayati/Controllers/Splash/splash_controller.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:overlay_support/overlay_support.dart';

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
    switch (i) {
      case 0:
        {
          Get.delete<ChatController>();
          Get.delete<HomeController>();
          Get.delete<ProfileController>();
          break;
        }
      case 1:
        {
          Get.delete<MusicController>();
          Get.delete<HomeController>();
          Get.delete<ProfileController>();
          // Get.delete<ChatController>();
          break;
        }
      case 2:
        {
          Get.delete<ChatController>();
          Get.delete<MusicController>();
          // Get.delete<TrainingController>();
          Get.delete<ProfileController>();
          break;
        }
      case 3:
        {
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
    Get.delete<SplashController>();
    Get.delete<LoginController>();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {
    //
    //     print('MMMMMMMMMMMMMMMMMMMMMMMM');
    //     print(message.data);
    //     // print('MMMMMMMMMMMMMMMMMMMMMMMM');
    //
    //   }
    // });
    super.onInit();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('MMMMMMMMMMMMMMMMMMMMMMMM');
    //   // PushNotification notification = PushNotification(
    //   //   title: message.notification?.title,
    //   //   body: message.notification?.body,
    //   // );
    //
    //   showSimpleNotification(
    //     Text("this is a message from simple notification"),
    //     background: Colors.green,
    //     contentPadding: paddingAll10
    //   );
    //
    //   // flutterLocalNotificationsPlugin.show(
    //   //   notification.hashCode,
    //   //   notification.title,
    //   //   notification.body,
    //   //   NotificationDetails(
    //   //     android: AndroidNotificationDetails(
    //   //       channel.id,
    //   //       channel.name,
    //   //       channelDescription: channel.description,
    //   //       // TODO add a proper drawable resource to android, for now using
    //   //       //      one that already exists in example app.
    //   //       icon: 'launch_background',
    //   //     ),
    //   //   ),
    //   // );
    // });
  }
}
