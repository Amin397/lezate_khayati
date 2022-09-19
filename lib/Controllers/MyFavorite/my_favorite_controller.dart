import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/MyFavorite/favorite_course_model.dart';
import 'package:lezate_khayati/Models/MyFavorite/favorite_post_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Utils/routing_utils.dart';

class MyFavoriteController extends GetxController {
  RxBool isLoaded = false.obs;

  TextEditingController searchTextController = TextEditingController();

  List<FavoritePostModel> favoritePostList = [];
  List<FavoriteCourseModel> favoriteCourseList = [];
  RxInt currentTab = 0.obs;

  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentTab.value);
    getFavorite(mode: 'post');
    getFavorite(mode: 'course');
    super.onInit();
  }

  void getFavorite({required String mode}) async {
    ApiResult result = await RequestsUtil.instance.getFavorites(
      mode: mode,
    );

    if (result.isDone) {
      if (mode == 'post') {
        favoritePostList = FavoritePostModel.listFromJson(result.data);
        update(['favePost']);
      } else {
        favoriteCourseList = FavoriteCourseModel.listFromJson(result.data);
        update(['faveCourse']);
      }
      isLoaded(true);
    }
  }

  void goToSingleArticle({
    required FavoritePostModel article,
    required int index,
  }) {
    Get.toNamed(RoutingUtils.singleArticle.name, arguments: {
      'index': index,
      'id': article.post!.first.id,
      'image': article.post!.first.img,
      'name': article.post!.first.name,
    });
  }


  void goToPriceyCourse({
    required Course course,
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



  void search({required String text}) {
    print('================');

    if(currentTab.value == 0){
      if (text.isEmpty) {
        favoritePostList.forEach((element) {
          element.visible(true);
        });
      } else {
        favoritePostList.forEach((element) {
          if (!element.post!.first.name!.contains(text)) {
            element.visible(false);
          } else {
            element.visible(true);
          }
        });
      }
      update(['favePost']);
    }else{
      if (text.isEmpty) {
        favoriteCourseList.forEach((element) {
          element.visible(true);
        });
      } else {
        favoriteCourseList.forEach((element) {
          if (!element.course!.first.name!.contains(text)) {
            element.visible(false);
          } else {
            element.visible(true);
          }
        });
      }
      update(['faveCourse']);
    }
  }

  void changeTab({required int page}) {
    searchTextController.clear();
    currentTab(page);
    pageController.animateToPage(
      currentTab.value,
      duration: Duration(milliseconds: 270),
      curve: Curves.linear,
    );
  }

  void changeCurrentIndex({required int page}) {
    currentTab(page);
  }
}
