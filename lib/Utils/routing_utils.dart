import 'package:lezate_khayati/Controllers/Main/main_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Views/Login/login_screen.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';
import 'package:lezate_khayati/Views/Training/Books/books_screen.dart';
import 'package:lezate_khayati/Views/Training/PublicTraining/public_training.dart';

import '../Views/Main/main_screen.dart';
import '../Views/MainMore/main_more_screen.dart';
import '../Views/Training/Classes/classes_screen.dart';
import '../Views/Training/FreeTraining/free_training.dart';


class RoutingUtils {
  static GetPage splash = GetPage(
    name: '/',
    page: () => SplashScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage login = GetPage(
    name: '/login',
    page: () => LoginScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage main = GetPage(
    name: '/main',
    page: () => MainScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage books = GetPage(
    name: '/books',
    page: () => BooksScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage classes = GetPage(
    name: '/classes',
    page: () => ClassesScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage publicTraining = GetPage(
    name: '/publicTraining',
    page: () => PublicTrainingScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage freeTraining = GetPage(
    name: '/freeTraining',
    page: () => FreeTrainingScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage mainMore = GetPage(
    name: '/mainMore',
    page: () => MainMoreScreen(),
    transition: Transition.fadeIn,
  );
}
