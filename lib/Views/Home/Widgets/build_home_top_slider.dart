import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Home/home_controller.dart';
import 'package:lezate_khayati/Models/Home/home_top_slider_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:shimmer/shimmer.dart';

class BuildHomeTopSliderWidget extends StatelessWidget {
  const BuildHomeTopSliderWidget({Key? key, required this.controller})
      : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .3,
      child: Obx(
        () => (controller.sliderLoaded.isTrue)
            ? PageView.builder(
                onPageChanged: (index) {
                  controller.sliderCurrentIndex(index);
                },
                itemCount: controller.sliderList.length,
                physics: BouncingScrollPhysics(),
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                controller: controller.pageController,
                itemBuilder: (BuildContext context, int index) => _buildSlider(
                  banner: controller.sliderList[index],
                  index: index,
                ),
              )
            : _buildShimmer(),
      ),
    );
  }

  Widget _buildSlider({
    required HomeTopSliderModel banner,
    required int index,
  }) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: Get.width,
        height: double.maxFinite,
        margin: EdgeInsets.symmetric(
          horizontal: Get.width * .02,
          vertical: (controller.sliderCurrentIndex.value == index)
              ? Get.height * .03
              : Get.height * .045,
        ),
        decoration: BoxDecoration(
          boxShadow: (controller.sliderCurrentIndex.value == index)
              ? ViewUtils.neoShadow()
              : [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 5.0,
                    blurRadius: 5.0,
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: radiusAll12,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              banner.img!,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      width: 200.0,
      height: 100.0,
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
    );
  }
}
