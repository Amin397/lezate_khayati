import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/product_category_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Utils/routing_utils.dart';

class ProductCategoryController extends GetxController {
  RxBool isLoaded = false.obs;

  TextEditingController searchTextController = TextEditingController();

  List<ProductCategoryModel> showProductCategory = [];

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    ApiResult result = await RequestsUtil.instance.getProductsCategory();

    if (result.isDone) {
      showProductCategory = ProductCategoryModel.listFromJson(result.data);
      isLoaded(true);
    }
  }

  void search({required String text}) {
    if (text.isEmpty) {
      showProductCategory.forEach((element) {
        element.visible(true);
      });
    } else {
      showProductCategory.forEach((element) {
        if (!element.name!.contains(text)) {
          element.visible(false);
        } else {
          element.visible(true);
        }
      });
    }
  }

  void goToProduct({
    required int index,
    required ProductCategoryModel product,
  }) {
    Get.toNamed(
      RoutingUtils.mainMore.name,
      arguments: {
        'id': 2,
        'title': product.name,
        'catId': product.id,
      },
    );
  }
}
