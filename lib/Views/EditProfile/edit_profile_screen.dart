import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

import '../../Controllers/EditProfile/edit_profile_controller.dart';
import '../../Utils/color_utils.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange.shade700,
        onPressed: () {},
        label: Row(
          children: [
            Icon(Icons.check),
            SizedBox(width: 8.0,),
            Text(
              'ذخیره',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildImage(),
              SizedBox(
                height: Get.height * .03,
              ),
              name(),
              postalCode(),
              city(),
              address(),
              SizedBox(
                height: Get.height * .01,
              ),
              _buildBirthDay(),
              _buildGender(),
              SizedBox(
                height: Get.height * .1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBirthDay() {
    return InkWell(
      onTap: () {
        controller.openDatePicker();
      },
      child: GetBuilder(
        id: 'birthDay',
        init: controller,
        builder: (ctx) => Container(
          width: Get.width,
          height: Get.height * .06,
          margin: paddingAll10,
          padding: paddingAll10,
          decoration: BoxDecoration(
            borderRadius: radiusAll10,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              controller.birthDay,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGender() {
    return GetBuilder(
      init: controller,
      id: 'gender',
      builder: (ctx) => Container(
        width: Get.width,
        height: Get.height * .07,
        padding: paddingAll10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Radio<String>(
                    value: "male",
                    groupValue: controller.selectedGender,
                    onChanged: (value) {
                      controller.changeGender(value: value!);
                    }),
                Text(
                  'مرد',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Radio<String>(
                    value: "female",
                    groupValue: controller.selectedGender,
                    onChanged: (value) {
                      controller.changeGender(value: value!);
                    }),
                Text(
                  'زن',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String name,
    void Function(String)? onChange,
    int maxLen = 9999,
    TextAlign align = TextAlign.right,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: paddingSymmetricH24,
        child: TextFormField(
          textAlign: align,
          controller: controller,
          onChanged: onChange,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              maxLen,
            ),
          ],
          style: TextStyle(
            color: Colors.black,
          ),
          cursorColor: ColorUtils.yellow,
          decoration: InputDecoration(
            labelText: name,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorUtils.yellow,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            // labelStyle: TextStyle(
            //   color: Colors.white.withOpacity(0.7),
            // ),
          ),
        ),
      ),
    );
  }

  Widget postalCode() {
    return _textInput(
      controller: controller.postalCodeController,
      name: "کد پستی",
    );
  }

  Widget address() {
    return _textInput(
      controller: controller.addressController,
      name: "آدرس",
    );
  }

  Widget city() {
    return _textInput(
      controller: controller.cityController,
      name: "شهر",
    );
  }

  Widget name() {
    return _textInput(
      controller: controller.nameController,
      name: "نام و نام خانوادگی",
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

  Widget _buildImage() {
    return GetBuilder(
      init: controller,
      id: 'updateAvatar',
      builder: (ctx) => Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: Get.width,
              height: Get.height * .35,
              margin: paddingAll10,
              decoration: BoxDecoration(
                borderRadius: radiusAll12,
                color: (controller.avatar is File)
                    ? Colors.white
                    : (Globals.userStream.user!.avatar is String)
                        ? Colors.transparent
                        : Colors.grey.withOpacity(.5),
              ),
              child: (controller.avatar is XFile)
                  ? ClipRRect(
                      borderRadius: radiusAll12,
                      child: Image(
                        image: FileImage(File(controller.avatar!.path)),
                        fit: BoxFit.cover,
                      ),
                    )
                  : (Globals.userStream.user!.avatar is String)
                      ? Hero(
                          tag: 'profileTag',
                          child: ClipRRect(
                            borderRadius: radiusAll12,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                Globals.userStream.user!.avatar!,
                              ),
                              placeholder: AssetImage(
                                'assets/img/placeHolder.jpg',
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 40.0,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              'عکسی وجود ندارد',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
          Positioned(
            bottom: -15.0,
            right: 25.0,
            child: InkWell(
              onTap: () {
                controller.pickImage();
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: ViewUtils.neoShadow(),
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
