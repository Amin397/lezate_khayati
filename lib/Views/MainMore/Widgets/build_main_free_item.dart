import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/free_courses_model.dart';

import '../../../Controllers/MainMore/main_more_controller.dart';
import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildMainFreeItem extends StatelessWidget {
  const BuildMainFreeItem(
      {Key? key,
      required this.index,
      required this.controller,
      required this.freeItem})
      : super(key: key);

  final MainMoreController controller;
  final FreeCoursesModel freeItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        controller.goToFreeCourse(
          course: freeItem,
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
            _buildImage(),
            _buildShadow(),
            _buildRateAndView(
              course: freeItem,
            ),
            _buildCourseNameAndTeacherName(),
          ],
        ),
      ),
    );
  }

  Widget _buildRateAndView({required FreeCoursesModel course}) {
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

  Widget _buildCourseNameAndTeacherName() {
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
                      freeItem.name!,
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
                              freeItem.teacher!,
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

  Widget _buildImage() {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            freeItem.img!,
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
