import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Search/search_controller.dart';
import 'package:lezate_khayati/Models/Search/search_course_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildSearchCoursesWidget extends StatelessWidget {
  const BuildSearchCoursesWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: Get.height,
        width: Get.width,
        child: GetBuilder(
          init: controller,
          id: 'showSearch',
          builder: (ctx) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: ((Get.width / 2) / (Get.height * .16) / 2),
            ),
            shrinkWrap: true,
            itemBuilder: (_, index) => _buildCourseItem(
              course: controller.coursesList[index],
              index: index,
            ),
            itemCount: controller.coursesList.length,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(
      {required SearchCourseModel course, required int index}) {
    return InkWell(
      onTap: () {
        controller.goToSingleCourse(
          course: course,
          index: index,
        );
      },
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: paddingAll12,
        decoration: BoxDecoration(
          borderRadius: radiusAll10,
          boxShadow: ViewUtils.neoShadow(),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildImage(
              image: course.img!,
            ),
            _buildShadow(),
            _buildRateAndView(
              course: course,
            ),
            _buildCourseNameAndTeacherName(
              course: course,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateAndView({required SearchCourseModel course}) {
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

  Widget _buildCourseNameAndTeacherName({required SearchCourseModel course}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: Get.width,
          height: Get.height * .08,
          padding: paddingAll4,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      course.name!,
                      maxFontSize: 18.0,
                      minFontSize: 12.0,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: paddingSymmetricH8,
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'استاد :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AutoSizeText(
                              course.teacher!,
                              maxLines: 2,
                              maxFontSize: 18.0,
                              minFontSize: 12.0,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage({required String image}) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            image,
          ),
          placeholder: AssetImage(
            'assets/img/placeHolder.jpg',
          ),
        ),
      ),
    );
  }

  Widget _buildShadow() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
        color: Colors.black38,
      ),
    );
  }
}
