import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Controllers/Login/login_controller.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Models/user_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Utils/storage_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:lezate_khayati/Utils/widget_utils.dart';

class CompleteRegister extends StatefulWidget {
  final String mobile;
  final String code;
  final LoginController controller;

  const CompleteRegister({
    required this.mobile,
    required this.code,
    required this.controller,
  });

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'تکمیل اطلاعات',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Get.height / 3,
        width: Get.width / 1.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          color: ColorUtils.black,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 48,
                ),
                header(),
                SizedBox(
                  height: Get.height / 48,
                ),
                Expanded(
                  child: body(),
                ),
                SizedBox(
                  height: Get.height / 48,
                ),
                finalBtn(),
                SizedBox(
                  height: Get.height / 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget finalBtn() {
    return WidgetUtils.softButton(
      title: "ثبت نام",
      onTap: () => finalize(),
      enabled: true,
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          name(),
          SizedBox(
            height: Get.height / 48,
          ),
          lastName(),
        ],
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String name,
    void Function(String)? onChange,
    required FocusNode focusNode,
    int maxLen = 9999,
    TextAlign align = TextAlign.right,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        textAlign: align,
        controller: controller,
        onChanged: onChange,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          LengthLimitingTextInputFormatter(
            maxLen,
          ),
        ],
        style: const TextStyle(
          color: Colors.white,
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
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget name() {
    return _textInput(
      controller: nameController,
      focusNode: nameFocusNode,
      name: "نام",
    );
  }

  Widget lastName() {
    return _textInput(
      controller: lastNameController,
      focusNode: lastNameFocusNode,
      name: "نام خانوادگی",
    );
  }

  void finalize() {
    EasyLoading.show();
    widget.controller.requests
        .completeRegister(
      name: nameController.text,
      lastName: lastNameController.text,
      code: widget.code,
      mobile: widget.mobile,
    )
        .then((ApiResult result) {
      EasyLoading.dismiss();
      if (result.isDone) {
        StorageUtils.saveUser(widget.mobile.toString());
        Globals.userStream.changeUser(UserModel.fromJson(result.data['info']));
        ViewUtils.showSuccessDialog(
          "Go to index",
        );
        // Get.offAllNamed(
        //   RoutingUtils.index.name,
        // );
      } else {
        ViewUtils.showErrorDialog(
          result.data['message'],
        );
      }
    });
  }
}
