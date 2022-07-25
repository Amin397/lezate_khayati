import 'package:flutter/material.dart';

import '../../../Controllers/Training/Books/books_controller.dart';
import '../../../Plugins/get/get.dart';
import 'Widgets/build_articles_widget.dart';
import 'Widgets/build_books_widget.dart';

class BooksScreen extends StatelessWidget {
  BooksScreen({Key? key}) : super(key: key);

  final BooksController controller = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'مقالات و کتاب ها',
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(
                Icons.article_rounded,
              ),
              text: 'مقالات',
            ),
            Tab(
              icon: Icon(
                Icons.menu_book_rounded,
              ),
              text: 'کتاب ها',
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: <Widget>[
          BuildArticlesWidget(
            controller: controller,
          ),
          BuildBooksWidget(
            controller: controller,
          )
        ],
      ),
    );
  }
}
