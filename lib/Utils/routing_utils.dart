import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Views/Login/login_screen.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';

import '../Views/Main/main_screen.dart';


class RoutingUtils {
  static GetPage splash = GetPage(
    name: '/',
    page: () => SplashScreen(),
  );
  static GetPage login = GetPage(
    name: '/login',
    page: () => LoginScreen(),
  );
  static GetPage main = GetPage(
    name: '/main',
    page: () => MainScreen(),
  );
}
