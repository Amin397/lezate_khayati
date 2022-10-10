import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/free_courses_model.dart';
import 'package:lezate_khayati/Models/Home/home_articles_model.dart';
import 'package:lezate_khayati/Models/Home/pricey_courses_model.dart';
import 'package:lezate_khayati/Models/Home/product_category_model.dart';
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
  List<ProductCategoryModel> productsCategoryList = [];
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
      // productsList = ProductsModel.listFromJson(result.data['products']);
      freeCoursesList =
          FreeCoursesModel.listFromJson(result.data['freeCourses']);
      priceyCoursesList =
          PriceyCoursesModel.listFromJson(result.data['pricyCourses']);
    }

    getProductCategory();
  }

  getProductCategory() async {
    ApiResult result = await RequestsUtil.instance.getProductsCategory();

    if (result.isDone) {
      productsCategoryList = ProductCategoryModel.listFromJson(result.data);
    }

    isLoaded(true);
  }

  void showMore({
    required int id,
    required String title,
  }) {
    print(id);
    if (id == 2) {
      Get.toNamed(
        RoutingUtils.productCategory.name,
      );
    } else {
      Get.toNamed(
        RoutingUtils.mainMore.name,
        arguments: {
          'id': id,
          'title': title,
        },
      );
    }
  }

  void goToSearchPage() {
    Get.toNamed(
      RoutingUtils.searchPage.name,
    );
  }

  void goToSingle({
    required int id,
    required int index,
  }) {
    switch (id) {
      case 0:
        {
          goToPriceyCourse(
            index: index,
            course: priceyCoursesList[index],
          );
          break;
        }
      case 1:
        {
          goToFreeCourse(
            index: index,
            course: freeCoursesList[index],
          );
          break;
        }
      case 2:
        {
          goToSingleProduct(
            index: index,
            product: productsList[index],
          );
          break;
        }
      case 3:
        {
          goToSingleBook(
            index: index,
            book: booksList[index],
          );
          break;
        }
      case 4:
        {
          goToSingleArticle(
            index: index,
            article: articlesList[index],
          );
          break;
        }
    }
  }

  void goToPriceyCourse({
    required PriceyCoursesModel course,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singlePriceyCourse.name, arguments: {
      'index': index,
      'id': course.id,
      'image': course.img,
      'name': course.name,
      'free': false,
    });
  }

  void goToFreeCourse({
    required FreeCoursesModel course,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singlePriceyCourse.name, arguments: {
      'index': index,
      'id': course.id,
      'image': course.img,
      'name': course.name,
      'free': true,
    });
  }

  void goToSingleProduct({
    required int index,
    required ProductsModel product,
  }) {
    Get.toNamed(RoutingUtils.singleProduct.name, arguments: {
      'index': index,
      'id': product.id,
      'image': product.img,
      'name': product.name,
    });
  }

  void goToSingleBook({
    required BooksModel book,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singleBook.name, arguments: {
      'index': index,
      'id': book.id,
      'image': book.img,
      'name': book.name,
    });
  }

  void goToSingleArticle({
    required HomeArticlesModel article,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singleArticle.name, arguments: {
      'index': index,
      'id': article.id,
      'image': article.img,
      'name': article.name,
    });
  }
}
