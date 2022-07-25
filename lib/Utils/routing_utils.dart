import 'package:lezate_khayati/Controllers/Main/main_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Views/Login/login_screen.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';
import 'package:lezate_khayati/Views/Training/Books/books_screen.dart';
import 'package:lezate_khayati/Views/Training/PublicTraining/public_training.dart';

import '../Views/Main/main_screen.dart';
import '../Views/Training/Classes/classes_screen.dart';
import '../Views/Training/FreeTraining/free_training.dart';


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
  static GetPage books = GetPage(
    name: '/books',
    page: () => BooksScreen(),
  );
  static GetPage classes = GetPage(
    name: '/classes',
    page: () => ClassesScreen(),
  );
  static GetPage publicTraining = GetPage(
    name: '/publicTraining',
    page: () => PublicTrainingScreen(),
  );
  static GetPage freeTraining = GetPage(
    name: '/freeTraining',
    page: () => FreeTrainingScreen(),
  );
}
