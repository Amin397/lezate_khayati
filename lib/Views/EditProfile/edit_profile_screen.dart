import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/EditProfile/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Container(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        'ویرایش پروفایل',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'editProfile',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/editProfile.png',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
