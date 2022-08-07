import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

import '../../Controllers/Search/search_controller.dart';
import '../../Models/Search/search_tab_model.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import 'Widgets/build_search_articles_widget.dart';
import 'Widgets/build_search_books_widget.dart';
import 'Widgets/build_search_courses_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      backgroundColor: Colors.grey[200],
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            _buildSearchBox(),
            _buildTabBar(),
            _buildPageView(),
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
      title: Hero(
        tag: 'search',
        child: Text(
          'جستجو',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      actions: [
        Hero(
          tag: 'searchIcon',
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: Get.width,
      height: Get.height * .07,
      child: Row(
        children: [
          _buildTabItem(
            tab: controller.tabList.first,
          ),
          _buildTabItem(
            tab: controller.tabList[1],
          ),
          _buildTabItem(
            tab: controller.tabList.last,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required SearchTabModel tab}) {
    return Flexible(
      flex: 1,
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectTab(tab: tab);
          },
          child: AnimatedContainer(
            margin: paddingAll10,
            duration: const Duration(milliseconds: 300),
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: (tab.isSelected.isTrue) ? Colors.red : Colors.white,
              borderRadius: (tab.isSelected.isTrue) ? radiusAll10 : radiusAll8,
              border: Border.all(
                color:
                    (tab.isSelected.isTrue) ? Colors.transparent : Colors.red,
                width: 1.5,
              ),
              boxShadow: (tab.isSelected.isTrue)
                  ? ViewUtils.neoShadow()
                  : [
                      BoxShadow(),
                    ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: AutoSizeText(
                    tab.title,
                    maxFontSize: 18.0,
                    maxLines: 1,
                    minFontSize: 12.0,
                    style: TextStyle(
                      fontSize: (tab.isSelected.isTrue) ? 16.0 : 14.0,
                      color: (tab.isSelected.isTrue)
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                (tab.searchCount.value == 0)
                    ? SizedBox()
                    : _buildBadges(
                        count: tab.searchCount,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: [
              BuildSearchArticlesWidget(
                controller: controller,
              ),
              BuildSearchCoursesWidget(
                controller: controller,
              ),
              BuildSearchBooksWidget(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadges({required RxInt count}) {
    return Positioned(
      top: -10.0,
      right: -5.0,
      child: Container(
        height: Get.width * .05,
        width: Get.width * .05,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // boxShadow: ViewUtils.neoShadow(),
          color: Colors.white,
          border: Border.all(
            color: Colors.blue.shade900,
          ),
        ),
        child: Center(
          child: AutoSizeText(
            count.value.toString(),
            maxLines: 1,
            maxFontSize: 16.0,
            minFontSize: 10.0,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
