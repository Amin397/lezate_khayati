import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Training/Books/articles_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../../Models/Training/Books/books_model.dart';

class BooksController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;

  RequestsUtil request = RequestsUtil();

  RxBool isLoaded = false.obs;
  RxBool bookLoaded = false.obs;

  List<BooksModel> booksList = [];
  List<ArticlesModel> articlesList = [];


  @override
  void onInit() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1,
    );

    getBooks();
    super.onInit();
  }

  void getBooks() async {
    ApiResult result = await request.getBooks();
    if (result.isDone) {
      booksList = BooksModel.listFromJson(result.data);
    }
    bookLoaded(true);
    getArticles();
  }

  void getArticles() async {
    ApiResult result = await request.getArticles();
    if (result.isDone) {
      articlesList = ArticlesModel.listFromJson(result.data);
      isLoaded(true);
    }
  }
}
