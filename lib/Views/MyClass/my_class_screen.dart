import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/MyClass/my_courses_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/MyClass/my_class_controller.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/view_utils.dart';

class MyClassScreen extends StatelessWidget {
  MyClassScreen({Key? key}) : super(key: key);

  final MyClassController controller = Get.put(MyClassController());

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
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Obx(
                      () =>
                  (controller.isLoaded.isTrue) ? _buildGridView() : _buildShimmer(),
                ),
              ),
            ),
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
      title: Text(
        'کلاس های من',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'myClass',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/myClass.png',
                ),
              ),
            ),
          ),
        )
      ],
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

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: ((Get.width / 2) / (Get.height * .16) / 2),
      ),
      shrinkWrap: true,
      itemBuilder: (_, index) => _buildCoursesItem(
        course: controller.courseList
            .where((element) => element.visible.isTrue)
            .toList()[index],
      ),
      itemCount: controller.courseList
          .where((element) => element.visible.isTrue)
          .toList()
          .length,
    );
  }

  Widget _buildCoursesItem({required MyCourseModel course}) {
    return Container(
      margin: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: radiusAll8,
            child: Image(
              image: AssetImage(
                'assets/img/testImage.png',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: radiusAll8,
            ),
          ),
          _buildName(
            course: course,
          ),
          _buildRateAndView(
            course: course,
          ),
        ],
      ),
    );
  }

  Widget _buildName({
    required MyCourseModel course,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: Get.width,
        height: Get.height * .06,
        child: Center(
          child: AutoSizeText(
            course.name!,
            maxLines: 2,
            maxFontSize: 20.0,
            minFontSize: 10.0,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRateAndView({required MyCourseModel course}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Get.height * .06,
        width: Get.width,
        padding: paddingAll6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRateBar(
              rate: course.reviewsRating!,
            ),
            _buildView(
              view: course.reviews!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateBar({required int rate}) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.star,
              color: (rate >= 1)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 2)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 3)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 4)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 5)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView({required int view}) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 15.0,
              color: Colors.white60,
            ),
            Text(
              view.toString(),
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
