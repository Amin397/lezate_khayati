import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/ProductCategory/product_category_controller.dart';
import '../../Plugins/get/get.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import 'Widgets/build_product_category_item.dart';

class ProductCategoryScreen extends StatelessWidget {
  ProductCategoryScreen({Key? key}) : super(key: key);


  final ProductCategoryController controller = Get.put(ProductCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppbar(),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .02,
            ),
            // _buildSearchBox(),
            // SizedBox(
            //   height: Get.height * .01,
            // ),
            Obx(
                  () => (controller.isLoaded.isTrue)
                  ? Expanded(
                    child: GetBuilder(
                      init: controller,
                      id: 'itemsList',
                      builder: (ctx) {
                        return Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: ((Get.width / 2) / (Get.height * .15) / 2),
                            ),
                            shrinkWrap: true,
                            itemBuilder: (_, index) => BuildProductCategoryItem(
                              controller: controller,
                              item:  controller.showProductCategory[index],
                              index: index,
                            ),
                            // itemCount: controller.showMoreItem!.length,
                            itemCount: controller.showProductCategory.length,
                          ),
                        );
                      },
                    ),
                  )
                  : _buildShimmer(),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildSearchBox() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          depth: -3,
          lightSource: LightSource.topLeft,
          color: Colors.grey[100],
        ),
        margin: paddingSymmetricH8,
        child: Container(
          width: Get.width,
          height: Get.height * .05,
          padding: paddingAll4,
          child: TextField(
            onChanged: (s) {
              controller.search(
                text: s,
              );
            },
            controller: controller.searchTextController,
            textAlign: TextAlign.start,
            maxLines: 1,
            cursorColor: Colors.black,
            style: TextStyle(
              color: ColorUtils.textColor,
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: 'جستجو',
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
              border: InputBorder.none,
            ),
            textAlignVertical: TextAlignVertical.bottom,
          ),
        ),
      ),
    );
  }



  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        'دسته بندی محصولات',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Container(
                          height: Get.height,
                          width: Get.height * .125,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(.2),
                            highlightColor: Colors.white24,
                            child: Container(
                              width: Get.width,
                              margin: paddingAll10,
                              height: Get.height * .25,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: radiusAll12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Container(
                          height: Get.height,
                          width: Get.height * .125,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(.2),
                            highlightColor: Colors.white24,
                            child: Container(
                              width: Get.width,
                              margin: paddingAll10,
                              height: Get.height * .25,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: radiusAll12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Container(
                          height: Get.height,
                          width: Get.height * .125,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(.2),
                            highlightColor: Colors.white24,
                            child: Container(
                              width: Get.width,
                              margin: paddingAll10,
                              height: Get.height * .25,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: radiusAll12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Container(
                          height: Get.height,
                          width: Get.height * .125,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(.2),
                            highlightColor: Colors.white24,
                            child: Container(
                              width: Get.width,
                              margin: paddingAll10,
                              height: Get.height * .25,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: radiusAll12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
