import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/MyFavorite/my_favorite_controller.dart';
import 'package:lezate_khayati/Models/MyFavorite/favorite_course_model.dart';

import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildCourseFavoriteWidget extends StatelessWidget {
  const BuildCourseFavoriteWidget({Key? key, required this.controller})
      : super(key: key);

  final MyFavoriteController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: GetBuilder(
        id: 'faveCourse',
        init: controller,
        builder: (ctx) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: ((Get.width / 2) / (Get.height * .15) / 2),
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) => _buildItem(
            index: index,
            item: controller.favoriteCourseList
                .where((element) => element.visible.isTrue)
                .toList()[index],
          ),
          // itemCount: controller.showMoreItem!.length,
          itemCount: controller.favoriteCourseList
              .where((element) => element.visible.isTrue)
              .length,
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required FavoriteCourseModel item,
  }) {
    return InkWell(
      onTap: () {
        controller.goToPriceyCourse(
          course: item.course!.first,
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
              index: index,
              image: item.course!.first.img,
            ),
            _buildShadow(),
            _buildRateAndView(
              course: item.course!.first,
            ),
            _buildCourseNameAndTeacherName(
              name: item.course!.first.name,
              teacher: item.course!.first.teacher,
            ),
            _buildPrice(
              price: item.course!.first.price,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRateAndView({required Course course}) {
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
              rate: double.parse(course.reviewsRating.toString()),
            ),
            _buildView(
              view: course.reviews!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateBar({required double rate}) {
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

  Widget _buildImage({required int index, String? image}) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Hero(
        tag: 'pricey-$index',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              image!,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
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

  Widget _buildCourseNameAndTeacherName({
    String? name,
    String? teacher,
  }) {
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
                      name!,
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
                              teacher!,
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

  Widget _buildPrice({String? price}) {
    return Positioned(
      bottom: Get.height * .06,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: paddingAll8,
          width: Get.width * .44,
          height: Get.height * .05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'قیمت :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      ViewUtils.moneyFormat(
                            double.parse(
                              price!,
                            ),
                          ) +
                          '  تومان',
                      maxLines: 1,
                      maxFontSize: 18.0,
                      minFontSize: 12.0,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
