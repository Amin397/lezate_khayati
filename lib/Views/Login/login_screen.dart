import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lezate_khayati/Controllers/Login/login_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Plugins/neumorphic-package-by-serge-software/neumorphic-card.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:lezate_khayati/Utils/widget_utils.dart';
import 'package:lezate_khayati/Widgets/Components/bezier_container.dart';
import 'package:lezate_khayati/Widgets/Components/circles.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(
    LoginController(),
  );
  LoginScreen({Key? key}) : super(key: key);
  List backGroundItems() {
    return [
      Positioned(
        right: Get.width / 1.4,
        top: Get.height / 2,
        child: Transform.rotate(
          angle: 3,
          child: BezierContainer(
            color: ColorUtils.yellow.shade300,
          ),
        ),
      ),
      Positioned(
        top: Get.height / 1.4,
        left: Get.width / 2,
        child: Transform.rotate(
          angle: 8,
          child: BezierContainer(
            color: ColorUtils.yellow.shade50,
          ),
        ),
      ),
      Positioned(
        right: Get.width / 0.85,
        top: Get.height / 4,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.yellow.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        right: Get.width / 1.2,
        top: Get.height / 4.5,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.yellow.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        left: Get.width / 1,
        top: Get.height / 1.2,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.yellow.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        left: Get.width / 0.95,
        top: Get.height / 4,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.yellow.withOpacity(
              0.2,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          backgroundColor: ColorUtils.black,
        ),
        ...backGroundItems(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: buildBody(),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          ViewUtils.sizedBox(48),
          Image.asset(
            'assets/img/logo.png',
            width: Get.width / 0.8,
            fit: BoxFit.fill,
          ),
          AutoSizeText(
            "ورود / ثبت نام",
            style: TextStyle(
              fontSize: 21.0,
              color: ColorUtils.yellow,
            ),
          ),
          SizedBox(
            height: Get.height / 12,
          ),
          mobileInput(),
          SizedBox(
            height: Get.height / 36,
          ),
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: controller.isLogin.value == true
                  ? Center(
                      child: Column(
                        children: [
                          codeInput(),
                          // SizedBox(
                          //   height: Get.height / 96,
                          // ),
                          // SizedBox(
                          //   width: Get.width * .8,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       GestureDetector(
                          //         child: const Text(
                          //           "رمز عبور خود را فرموش کرده ام",
                          //           style: TextStyle(
                          //             fontSize: 12.0,
                          //             color: Colors.blue,
                          //           ),
                          //         ),
                          //         onTap: () => controller.forgotPassword(),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: Get.height / 48,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            );
          }),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: controller.isRegister.value == true ||
                      controller.isForgot.value == true
                  ? Center(
                      child: Column(
                        children: [
                          codeInput(),
                          SizedBox(
                            height: Get.height / 48,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
          ),
          Obx(
            () => button(),
          ),
        ],
      ),
    );
  }

  Widget mobileInput() {
    return Obx(
      () => controller.isLogin.value == true ||
              controller.isRegister.value == true ||
              controller.isForgot.value == true
          ? GestureDetector(
              onTap: () {
                controller.isLogin.value = false;
                controller.isRegister.value = false;
                controller.isForgot.value = false;
                controller.passwordController.clear();
                controller.codeController.clear();
                controller.mobileFocusNode.requestFocus();
              },
              child: NeumorphicContainer(
                height: Get.height / 21,
                decoration: MyNeumorphicDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorUtils.black,
                ),
                curveType: CurveType.flat,
                bevel: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorUtils.yellow,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.edit,
                          size: 17.0,
                          color: ColorUtils.yellow,
                        ),
                      ),
                    ),
                    Text(
                      controller.mobileController.value.text,
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.9,
                        fontSize: 15.0,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorUtils.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.edit,
                          size: 17.0,
                          color: ColorUtils.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : WidgetUtils.textField(
              focusNode: controller.mobileFocusNode,
              controller: controller.mobileController.value,
              onChanged: controller.onChange,
              textAlign: TextAlign.center,
              formatter: [
                LengthLimitingTextInputFormatter(11),
              ],
              keyboardType: TextInputType.phone,
              title: "شماره موبایل",
            ),
    );
  }

  Widget passwordInput() {
    return WidgetUtils.textField(
      focusNode: controller.passwordNode,
      controller: controller.passwordController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      title: "رمز عبور",
    );
  }

  Widget codeInput() {
    return WidgetUtils.textField(
      focusNode: controller.codeFocusNode,
      controller: controller.codeController,
      textAlign: TextAlign.center,
      formatter: [
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (String string) {
        if (string.length > 3) {
          controller.submit();
        }
      },
      keyboardType: TextInputType.number,
      title: "کد تایید",
    );
  }

  Widget button() {
    return WidgetUtils.softButton(
      enabled: controller.mobileController.value.text.length == 11,
      title: controller.isLogin.value == true ? "ورود" : "مرحله بعد",
      onTap: () => controller.submit(),
    );
  }
}
