import 'package:lezate_khayati/Controllers/Main/main_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Views/Login/login_screen.dart';
import 'package:lezate_khayati/Views/Splash/splash_screen.dart';
import 'package:lezate_khayati/Views/Training/Books/books_screen.dart';
import 'package:lezate_khayati/Views/Training/PublicTraining/public_training.dart';

import '../Views/EditProfile/edit_profile_screen.dart';
import '../Views/JoinLive/join_live_screen.dart';
import '../Views/Live/Widgets/subscribers-screen.dart';
import '../Views/Live/live_screen.dart';
import '../Views/Lobby/lobby_screen.dart';
import '../Views/Main/main_screen.dart';
import '../Views/MainMore/main_more_screen.dart';
import '../Views/MyClass/my_class_screen.dart';
import '../Views/MyFavorite/my_favorite_screen.dart';
import '../Views/MyOrder/my_order_screen.dart';
import '../Views/MyQuestion/my_question_screen.dart';
import '../Views/Search/search_screen.dart';
import '../Views/SingleArticle/single_article_screen.dart';
import '../Views/SingleBook/single_book_screen.dart';
import '../Views/SingleChat/single_chat_screen.dart';
import '../Views/SinglePriceyCourse/single_pricey_course_screen.dart';
import '../Views/SingleProduct/single_product_screen.dart';
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
  static GetPage singlePriceyCourse = GetPage(
    name: '/singlePriceyCourse',
    page: () => SinglePriceyCourseScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage singleProduct = GetPage(
    name: '/singleProduct',
    page: () => SingleProductScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage singleBook = GetPage(
    name: '/singleBook',
    page: () => SingleBookScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage myClass = GetPage(
    name: '/myClass',
    page: () => MyClassScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage myOrder = GetPage(
    name: '/myOrder',
    page: () => MyOrderScreen(),
    transition: Transition.fadeIn,
  );
  // static GetPage myQuestion = GetPage(
  //   name: '/myQuestion',
  //   page: () => MyQuestionScreen(),
  //   transition: Transition.fadeIn,
  // );
  // static GetPage myFavorite = GetPage(
  //   name: '/myFavorite',
  //   page: () => MyFavoriteScreen(),
  //   transition: Transition.fadeIn,
  // );
  static GetPage editProfile = GetPage(
    name: '/editProfile',
    page: () => EditProfileScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage searchPage = GetPage(
    name: '/searchPage',
    page: () => SearchScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage singleArticle = GetPage(
    name: '/singleArticle',
    page: () => SingleArticleScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage singleChat = GetPage(
    name: '/singleChat',
    page: () => SingleChatScreen(),
    transition: Transition.fadeIn,
  );
  static GetPage lobby = GetPage(
    name: '/lobby',
    page: () => LobbyPage(),
    transition: Transition.fadeIn,
  );
  static GetPage live = GetPage(
    name: '/live',
    page: () => TypedVideoRoomV2Unified(),
    transition: Transition.fadeIn,
  );
  static GetPage joinLive = GetPage(
    name: '/joinLive',
    page: () => TypedVideoRoomV3Unified(),
    transition: Transition.fadeIn,
  );
}
