import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/MyFavorite/my_favorite_controller.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/view_utils.dart';
import 'Widgets/build_course_favorite_widget.dart';
import 'Widgets/build_postes_favorite_widget.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({Key? key}) : super(key: key);

  final MyFavoriteController controller = Get.put(MyFavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            _buildSearchBox(),
            SizedBox(
              height: 8.0,
            ),
            _buildTabBar(),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Obx(
                  () => (controller.isLoaded.isTrue)
                      ? PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller.pageController,
                          children: [
                            BuildPostsFavoriteWidget(
                              controller: controller,
                            ),
                            BuildCourseFavoriteWidget(
                              controller: controller,
                            ),
                          ],
                        )
                      : _buildShimmer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: Get.width,
      height: Get.height * .07,
      child: Row(
        children: [
          _buildTabItem(
            id: 0,
            title: 'دوره ها',
          ),
          _buildTabItem(
            id: 1,
            title: 'مقاله ها',
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int id,
    required String title,
  }) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          controller.changeTab(page: id);
        },
        child: Obx(()=>AnimatedContainer(
          margin: paddingAll10,
          duration: const Duration(milliseconds: 270),
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: (id == controller.currentTab.value) ? Colors.red : Colors.white,
            borderRadius:
            (id == controller.currentTab.value) ? radiusAll10 : radiusAll8,
            border: Border.all(
              color: (id == controller.currentTab.value)
                  ? Colors.transparent
                  : Colors.red,
              width: 1.5,
            ),
            boxShadow: (id == controller.currentTab.value)
                ? ViewUtils.neoShadow()
                : [
              BoxShadow(),
            ],
          ),
          child: Center(
            child: AutoSizeText(
              title,
              maxFontSize: 18.0,
              maxLines: 1,
              minFontSize: 12.0,
              style: TextStyle(
                fontSize: (id == controller.currentTab.value) ? 16.0 : 14.0,
                color: (id == controller.currentTab.value)
                    ? Colors.white
                    : Colors.grey.shade700,
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      height: Get.height,
      width: Get.width,
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
        margin: paddingAll10,
        child: Container(
          width: Get.width,
          height: Get.height * .05,
          padding: paddingAll4,
          child: TextField(
            onChanged: (s) {
              controller.search(text: s);
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
        'لیست علاقه مندی ها',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'myFavorite',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/favorite.png',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
