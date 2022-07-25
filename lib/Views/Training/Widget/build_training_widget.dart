import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lezate_khayati/Controllers/Training/training_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Plugins/neu/src/widget/container.dart';

import '../../../Utils/Consts.dart';

class BuildTrainingWidget extends StatelessWidget {
  const BuildTrainingWidget({Key? key, required this.controller})
      : super(key: key);

  final TrainingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            AnimationConfiguration.synchronized(
              child: FadeInAnimation(
                child: FadeInAnimation(
                  child: _buildTrainItem(
                    image: 'assets/img/image4.png',
                    title: 'کلاس ها',
                    color: 0xffE43187,
                    id: 0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * .02,
            ),
            AnimationConfiguration.synchronized(
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: _buildTrainItem(
                    image: 'assets/img/image1.png',
                    title: 'آموزش های رایگان',
                    color: 0xff7122D6,
                    id: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * .02,
            ),
            AnimationConfiguration.synchronized(
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: _buildTrainItem(
                    image: 'assets/img/image3.png',
                    title: 'کتاب ها ومقالات',
                    color: 0xffFC4C4C,
                    id: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * .02,
            ),
            AnimationConfiguration.synchronized(
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: _buildTrainItem(
                    image: 'assets/img/image2.png',
                    title: 'آموزش های عمومی',
                    color: 0xff029523,
                    id: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainItem({
    required String title,
    required String image,
    required int color,
    required int id,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        depth: 3,
        lightSource: LightSource.topLeft,
        color: Colors.grey[100],
      ),
      margin: paddingSymmetricH24,
      child: InkWell(
        onTap: () {
          controller.goToPage(
            id: id,
          );
        },
        child: Container(
          height: Get.height * .1,
          width: Get.width,
          padding: paddingAll12,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      title,
                      maxLines: 2,
                      maxFontSize: 18.0,
                      minFontSize: 12.0,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(color),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width * .1,
                height: double.maxFinite,
                child: Image(
                  image: AssetImage(
                    image,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
