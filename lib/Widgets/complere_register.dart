import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Controllers/Login/login_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/widget_utils.dart';

import '../Utils/Api/project_request_utils.dart';
import '../Utils/routing_utils.dart';
import '../Utils/view_utils.dart';

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

  String refer = '';

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
        height: Get.height * .3,
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
    return Column(
      children: [
        name(),
        SizedBox(
          height: Get.height / 48,
        ),
        fromWhere(),
      ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
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
      controller: widget.controller.nameController,
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

    Get.back(result: true);
    // EasyLoading.show();
    // widget.controller.requests
    //     .completeRegister(
    //   name: nameController.text,
    //   refer: widget.controller.refer,
    // )
    //     .then((ApiResult result) {
    //   EasyLoading.dismiss();
    //   if (result.isDone) {
    //     print(result.data);
    //     // StorageUtils.saveUser(widget.mobile.toString());
    //     // Globals.userStream.changeUser(UserModel.fromJson(result.data['info']));
    //
    //     Future.delayed(Duration(seconds: 3), () {
    //       Get.offAllNamed(
    //         RoutingUtils.main.name,
    //       );
    //     });
    //     ViewUtils.showSuccessDialog(
    //       "ثبت نام با موفقیت انجام شد",
    //     );
    //   } else {
    //     ViewUtils.showErrorDialog(
    //       result.data['message'],
    //     );
    //   }
    // });
  }

  Widget fromWhere() {
    return Expanded(
      child: Container(
        width: Get.width,
        height: double.maxFinite,
        child: Row(
          children: [
            Text(
              'نحوه آشنایی :',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            PopupMenuButton<int>(
              offset: const Offset(0, 50),
              shape: const TooltipShape(),
              onSelected: (item) {},
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  onTap: () {
                    setState(() {
                      refer = 'اینستاگرام';
                    });
                    widget.controller.changeRefer('اینستاگرام');
                  },
                  value: 1,
                  child: const Text(
                    'اینستاگرام',
                    style: TextStyle(
                      color: ColorUtils.textColor,
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  onTap: () {
                    setState(() {
                      refer = 'تلگرام';
                    });
                    widget.controller.changeRefer('تلگرام');
                  },
                  value: 2,
                  child: const Text('تلگرام',
                      style: TextStyle(
                        color: ColorUtils.textColor,
                      )),
                ),
                PopupMenuItem<int>(
                  onTap: () {
                    setState(() {
                      refer = 'گوگل';
                    });
                    widget.controller.changeRefer('گوگل');
                  },
                  value: 3,
                  child: const Text(
                    'گوگل',
                    style: TextStyle(
                      color: ColorUtils.textColor,
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  onTap: () {
                    setState(() {
                      refer = 'واتس اپ';
                    });
                    widget.controller.changeRefer('واتس اپ');
                  },
                  value: 4,
                  child: const Text(
                    'واتس اپ',
                    style: TextStyle(
                      color: ColorUtils.textColor,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
              ),
            ),
            Text(
              refer,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 50, 0);
    path.lineTo(rrect.width - 15, -15);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
