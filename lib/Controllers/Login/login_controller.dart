import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Models/user_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Utils/storage_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:lezate_khayati/Widgets/complere_register.dart';

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  RxBool isRegister = false.obs;
  RxBool isForgot = false.obs;
  RxBool getFingerprint = false.obs;
  Rx<TextEditingController> mobileController = (TextEditingController()).obs;
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final RequestsUtil requests = RequestsUtil();

  @override
  void onInit() async {
    // mobileController.value.text = await StorageUtils.getCustomersMobileBackup();
    // if (mobileController.value.text.length == 11) {
    //   start();
    // }
    // if (await PrefHelpers.getFingerPrint() == 'true') {
    //   getFingerprint.value = true;
    // }

    super.onInit();
  }

  // methods

  void onChange(String string) {
    List<String> list = string.split('');
    if (list.isNotEmpty) {
      switch (list.length) {
        case 1:
          if (list[0] == '0') {
            mobileController.value.text = '0';
          } else {
            mobileController.value.clear();
          }
          break;
        case 2:
          if (list[1] == '9') {
            mobileController.value.text = '09';
          } else {
            mobileController.value.text = '0';
          }

          break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
          list.removeAt(0);
          list.removeAt(0);
          mobileController.value.text = '09' + list.join('');
          break;
      }
      if (mobileController.value.text.length == 11) {
        submit();
      } else {
        Future.delayed(
          Duration.zero,
          () => mobileController.value.selection = TextSelection.fromPosition(
            TextPosition(
              offset: mobileController.value.text.length,
            ),
          ),
        );
      }
    }
  }

  void submit() {
    if (isForgot.value == true) {
      forgot();
    } else if (isRegister.value == true) {
      register();
    } else if (isLogin.value == true) {
      login();
    } else {
      start();
    }
  }

  void register() async {
    if (codeController.text.length != 4) {
      ViewUtils.showErrorDialog(
        "لطفا کد تایید را به صورت کامل وارد کنید (۴ رقم)",
      );
      return;
    }
    EasyLoading.show();
    ApiResult result = await requests.register(
      mobile: mobileController.value.text,
      code: codeController.text,
    );

    EasyLoading.dismiss();
    if (result.isDone) {
      Get.dialog(
        Directionality(
          textDirection: TextDirection.rtl,
          child: CompleteRegister(
            mobile: mobileController.value.text,
            code: codeController.value.text,
            controller: this,
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: true,
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data.toString(),
      );
    }
  }

  void login() async {
    if (codeController.text.length != 4) {
      ViewUtils.showErrorDialog(
        "لطفا کد تایید را به صورت کامل وارد کنید (۴ رقم)",
      );
      return;
    }
    // if (passwordController.text.length < 4) {
    //   ViewUtils.showErrorDialog(
    //     "لطفا رمز عبور را به درستی وارد کنید",
    //   );
    //   return;
    // }
    EasyLoading.show();
    // ApiResult result = await requests.login(
    //   mobile: mobileController.value.text,
    //   password: passwordController.text,
    // );
    ApiResult result = await requests.login(
      mobile: mobileController.value.text,
      password: codeController.text,
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      ViewUtils.showSuccessDialog(
        result.data['message'],
      );

      FocusScope.of(context).requestFocus(FocusNode());

      StorageUtils.saveUser(mobileController.value.text);

      // PrefHelpers.setMobile(mobileController.value.text.toString());
      Globals.userStream.changeUser(UserModel.fromJson(
        result.data,
      ));
      Future.delayed(const Duration(seconds: 3), () {
        toMainPage();
      });
    } else {
      ViewUtils.showErrorDialog(
        result.data.toString(),
      );
    }
  }

  void start() async {
    if (mobileController.value.text.length != 11) {
      ViewUtils.showErrorDialog(
        "لطفا موبایل را به درستی وارد کنید",
      );
      return;
    }
    EasyLoading.show();
    ApiResult result = await requests.startLoginRegister(
      mobile: mobileController.value.text,
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      isLogin.value = result.data['status'] == 1;
      if (isLogin.value) {
        // passwordNode.requestFocus();
        codeFocusNode.requestFocus();
      }
      isRegister.value =
          result.data['status'] == 0 || result.data['status'] == 'register';
      if (isRegister.value == true) {
        codeFocusNode.requestFocus();
      }
      ViewUtils.showInfoDialog(
        result.data?['message'],
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data?['message'],
      );
    }
  }

  void forgotPassword() async {
    EasyLoading.show();
    ApiResult result =
        await requests.forgotPassword(mobileController.value.text);
    EasyLoading.dismiss();

    if (result.isDone) {
      isForgot.value = true;
      codeFocusNode.requestFocus();
      isLogin.value = false;
      isRegister.value = false;
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'],
      );
    }
  }

  void forgot() async {
    EasyLoading.show();
    ApiResult result = await requests.forgotPasswordConfirm(
      mobileController.value.text,
      codeController.text,
    );
    EasyLoading.dismiss();

    if (result.isDone) {
      ViewUtils.showSuccessDialog(
        "رمز عبور جدید شما: ${codeController.text}",
      );
      // PrefHelpers.setCustomerId(result.data['customerId'].toString());
      // PrefHelpers.setMobile(this.mobileController.value.text.toString());
      // PrefHelpers.setCustomerIdBackup(
      //   result.data['customerId'].toString(),
      // );
      Globals.userStream
          .changeUser(UserModel.fromJson(result.data['customerData']));

      Future.delayed(const Duration(seconds: 2), () {
        toMainPage();
      });
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'],
      );
    }
  }

  void toMainPage() async {
    ViewUtils.showSuccessDialog(
      "Go to index",
    );
    // Get.offAndToNamed(
    //   RoutingUtils.index.name,
    // );
  }
}
