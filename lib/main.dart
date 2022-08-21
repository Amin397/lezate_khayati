import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Globals/Globals.dart';
import 'Plugins/get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  await GetStorage.init();
  RequestsUtil.token = 'test';

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
    print(message.data);

    if(message.data['title']== 'کنفرانس'){
      Globals.liveStream.setTrue(id:message.data['id'].toString());
    }
  });

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
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
          RoutingUtils.searchPage,
          RoutingUtils.singleArticle,
          RoutingUtils.singleChat,
          RoutingUtils.live,
          RoutingUtils.joinLive,
        ],
        builder: EasyLoading.init(),
        home: SplashScreen(),
      ),
    ),
  );
}
