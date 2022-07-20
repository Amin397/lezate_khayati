import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Profile/profile_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

class BuildMenuWidget extends StatelessWidget {
  const BuildMenuWidget({Key? key, required this.controller}) : super(key: key);

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: paddingSymmetricH16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusAll10,
        ),
        child: Column(
          children: [
            _buildTitle(),
            SizedBox(
              height: Get.height * .05,
            ),
            _buildMenuItem(
              id: 0,
              title: 'کلاس های من',
              image: 'assets/img/myClass.png',
            ),
            Divider(),
            _buildMenuItem(
              id: 1,
              title: 'رویداد های آموزشی من',
              image: 'assets/img/myTrainingEvent.png',
            ),
            Divider(),
            _buildMenuItem(
              id: 2,
              title: 'سفارش های من',
              image: 'assets/img/myOrder.png',
            ),
            Divider(),
            _buildMenuItem(
              id: 3,
              title: 'پرسش های من',
              image: 'assets/img/myQuestion.png',
            ),
            Divider(),
            _buildMenuItem(
              id: 4,
              title: 'لیست علاقه مندی ها',
              image: 'assets/img/favorite.png',
            ),
            Divider(),
            _buildMenuItem(
              id: 5,
              title: 'ویرایش پروفایل',
              image: 'assets/img/editProfile.png',
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        top: Get.height * .02,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'فهرست',
          style: TextStyle(
            fontSize: 18.0,
            color: ColorUtils.textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required int id,
    required String image,
    required String title,
  }) {
    return Container(
      padding: paddingSymmetricH8,
      width: Get.width,
      height: Get.height * .06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(
                  image,
                ),
              ),
              SizedBox(
                width: Get.width * .02,
              ),
              Text(title)
            ],
          ),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
