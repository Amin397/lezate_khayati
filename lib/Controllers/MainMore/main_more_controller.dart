import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/free_courses_model.dart';
import 'package:lezate_khayati/Models/Home/home_articles_model.dart';
import 'package:lezate_khayati/Models/Home/products_model.dart';
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';

import '../../Models/Home/pricey_courses_model.dart';

class MainMoreController extends GetxController {
  late final int id;
  late final String title;

  List? showMoreItem = [];

  RxBool isLoaded = false.obs;

  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    title = Get.arguments['title'];
    id = Get.arguments['id'];

    getData();

    super.onInit();
  }

  void getData() {
    switch (id) {
      case 0:
        {
          getPriceyCoursesData();
          break;
        }
      case 1:
        {
          getFreeCoursesData();
          break;
        }
      case 2:
        {
          getProductData();
          break;
        }
      case 3:
        {
          getBooksData();
          break;
        }
      case 4:
        {
          getArticlesData();
          break;
        }
    }
  }

  void getPriceyCoursesData() async {
    ApiResult result = await RequestsUtil.instance.getPriceyCoursesData();
    if (result.isDone) {
      showMoreItem = PriceyCoursesModel.listFromJson(result.data);
      update(['itemsList']);

      isLoaded(true);
    }
  }

  void getBooksData() async {
    ApiResult result = await RequestsUtil.instance.getBooks();
    if (result.isDone) {
      showMoreItem = BooksModel.listFromJson(result.data);
      update(['itemsList']);
      isLoaded(true);
    }
  }

  void getFreeCoursesData() async {
    ApiResult result = await RequestsUtil.instance.getFreeCoursesData();
    if (result.isDone) {
      showMoreItem = FreeCoursesModel.listFromJson(result.data);
      update(['itemsList']);
      isLoaded(true);
    }
  }

  void getProductData() async {
    ApiResult result = await RequestsUtil.instance.getProductsData();
    if (result.isDone) {
      showMoreItem = ProductsModel.listFromJson(result.data);
      update(['itemsList']);
      isLoaded(true);
    }
  }

  void getArticlesData() async {
    ApiResult result = await RequestsUtil.instance.getArticlesData();
    if (result.isDone) {
      showMoreItem = HomeArticlesModel.listFromJson(result.data);
      update(['itemsList']);
      isLoaded(true);
    }
  }

  void goToPriceyCourse({
    required PriceyCoursesModel course,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singlePriceyCourse.name, arguments: {
      'index': index,
      'id': course.id,
      'image':course.img,
      'name':course.name,
      'free':false,
    });
  }

  void goToFreeCourse({
    required FreeCoursesModel course,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singlePriceyCourse.name, arguments: {
      'index': index,
      'id': course.id,
      'image':course.img,
      'name':course.name,
      'free':true,
    });
  }

  void goToSingleProduct({required int index, required ProductsModel product}) {
    Get.toNamed(RoutingUtils.singleProduct.name , arguments: {
      'index': index,
      'id': product.id,
      'image':product.img,
      'name':product.name,
    });
  }

  void goToSingleBook({required BooksModel book, required int index}) {
    Get.toNamed(RoutingUtils.singleBook.name , arguments: {
      'index': index,
      'id': book.id,
      'image':book.img,
      'name':book.name,
    });
  }


  void search({required String text}) {
    if (text.isEmpty) {
      showMoreItem!.forEach((element) {
        element.visible(true);
      });
    } else {
      showMoreItem!.forEach((element) {
        if (!element.name!.contains(text)) {
          element.visible(false);
        } else {
          element.visible(true);
        }
      });
    }
  }




}
