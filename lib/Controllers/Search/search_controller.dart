import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/Search/search_article_model.dart';
import '../../Models/Search/search_course_model.dart';
import '../../Models/Search/search_tab_model.dart';
import '../../Utils/routing_utils.dart';

class SearchController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  List<SearchArticleModel> articlesList = [];
  List<SearchCourseModel> coursesList = [];
  List<BooksModel> booksList = [];
  RxBool isSearching = false.obs;

  late PageController pageController;

  List<SearchTabModel> tabList = [
    SearchTabModel(
      id: 0,
      title: 'مقاله ها',
      isSelected: false.obs,
      searchCount: 0.obs,
    ),
    SearchTabModel(
      id: 1,
      title: 'دوره ها',
      isSelected: false.obs,
      searchCount: 0.obs,
    ),
    SearchTabModel(
      id: 2,
      title: 'کتاب ها',
      isSelected: true.obs,
      searchCount: 0.obs,
    ),
  ];

  @override
  void onInit() {
    pageController = PageController(
      initialPage: 2,
    );
    super.onInit();
  }

  void search({required String text}) async {
    if (text.isEmpty) {
      articlesList.clear();
      coursesList.clear();
      booksList.clear();

      tabList.forEach((element) {
        element.searchCount(0);
      });
    } else {
      EasyLoading.show();
      ApiResult result = await RequestsUtil.instance.search(
        text: text,
      );
      EasyLoading.dismiss();

      if (result.isDone) {
        articlesList = SearchArticleModel.listFromJson(result.data['posts']);
        coursesList = SearchCourseModel.listFromJson(result.data['courses']);
        booksList = BooksModel.listFromJson(result.data['books']);

        tabList.first.searchCount(articlesList.length);
        tabList[1].searchCount(coursesList.length);
        tabList.last.searchCount(booksList.length);
      }
    }

    update(['showSearch']);
  }

  void selectTab({
    required SearchTabModel tab,
  }) {
    tabList.forEach((element) {
      element.isSelected(false);
    });
    tab.isSelected(true);
    pageController.animateToPage(
      tab.id,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void goToSingleBook({required BooksModel book, required int index}) {
    Get.toNamed(RoutingUtils.singleBook.name, arguments: {
      'index': index,
      'id': book.id,
      'image': book.img,
      'name': book.name,
    });
  }

  void goToSingleCourse({required SearchCourseModel course, required int index}) {
    Get.toNamed(RoutingUtils.singlePriceyCourse.name, arguments: {
      'index': index,
      'id': course.id,
      'image':course.img,
      'name':course.name,
    });
  }
}
