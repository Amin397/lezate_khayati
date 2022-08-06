import 'package:flutter/material.dart';

import '../../../Controllers/MainMore/main_more_controller.dart';
import '../../../Plugins/get/get.dart';
import 'build_article_item.dart';
import 'build_main_book_item.dart';
import 'build_main_free_item.dart';
import 'build_main_pricey_item.dart';
import 'build_product_item.dart';

class BuildMoreItemsWidget extends StatelessWidget {
  const BuildMoreItemsWidget({Key? key, required this.controller})
      : super(key: key);

  final MainMoreController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder(
        init: controller,
        id: 'itemsList',
        builder: (ctx) {
          return Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ((Get.width / 2) / (Get.height * .15) / 2),
              ),
              shrinkWrap: true,
              itemBuilder: (_, index) => _buildItem(
                index: index,
                item: controller.showMoreItem![index],
              ),
              // itemCount: controller.showMoreItem!.length,
              itemCount: controller.showMoreItem!.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required item,
  }) {
    switch (controller.id) {
      case 0:
        {
          return BuildMainPriceyItem(
            controller: controller,
            priceyCourse: item,
            index: index,
          );
        }
      case 1:
        {
          return BuildMainFreeItem(
            controller: controller,
            freeItem: item,
            index: index,
          );
        }
      case 2:
        {
          return BuildProductItem(
            controller: controller,
            productItem: item,
            index: index,
          );
        }
      case 3:
        {
          return BuildMainBookItem(
            controller: controller,
            book: item,
            index: index,
          );
        }
      default:
        {
          return BuildArticleItem(
            controller: controller,
            index: index,
            article: item,
          );
        }
    }
  }
}
