import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

import '../../Controllers/Profile/profile_controller.dart';
import 'Widget/build_menu_widget.dart';
import 'Widget/build_profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.grey[200],
      padding: paddingAll12,
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .035,
          ),
          BuildProfileWidget(
            controller: controller,
          ),
          SizedBox(
            height: Get.height * .035,
          ),
          BuildMenuWidget(
            controller: controller,
          ),
        ],
      ),
    );
  }
}
