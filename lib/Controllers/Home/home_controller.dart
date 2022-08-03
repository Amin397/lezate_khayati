import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/free_courses_model.dart';
import 'package:lezate_khayati/Models/Home/home_articles_model.dart';
import 'package:lezate_khayati/Models/Home/pricey_courses_model.dart';
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';

import '../../Models/Home/home_top_slider_model.dart';
import '../../Models/Home/products_model.dart';

class HomeController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  RxBool isLoaded = false.obs;
  RxBool sliderLoaded = false.obs;

  RxInt sliderCurrentIndex = 0.obs;

  late PageController pageController;

  List<HomeTopSliderModel> sliderList = [];
  List<BooksModel> booksList = [];
  List<HomeArticlesModel> articlesList = [];
  List<ProductsModel> productsList = [];
  List<PriceyCoursesModel> priceyCoursesList = [];
  List<FreeCoursesModel> freeCoursesList = [];

  @override
  void onInit() {
    pageController = PageController(
      initialPage: sliderCurrentIndex.value,
      viewportFraction: .85,
    );
    getHomeData();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  void getHomeData() async {
    ApiResult result = await RequestsUtil.instance.getHomeData();
    if (result.isDone) {
      sliderList = HomeTopSliderModel.listFromJson(result.data);
      sliderLoaded(true);
      getOtherData();
    }
  }

  void getOtherData() async {
    ApiResult result = await RequestsUtil.instance.getHomeOtherData();

    if (result.isDone) {
      booksList = BooksModel.listFromJson(result.data['books']);
      articlesList = HomeArticlesModel.listFromJson(result.data['articles']);
      productsList = ProductsModel.listFromJson(result.data['products']);
      freeCoursesList =
          FreeCoursesModel.listFromJson(result.data['freeCourses']);
      priceyCoursesList =
          PriceyCoursesModel.listFromJson(result.data['pricyCourses']);
    }

    isLoaded(true);
  }

  void showMore({
    required int id,
    required String title,
  }) {
    Get.toNamed(RoutingUtils.mainMore.name, arguments: {
      'id': id,
      'title': title,
    });
  }
}
