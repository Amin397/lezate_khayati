import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Globals/Globals.dart';
import '../../Models/user_model.dart';
import '../../Utils/routing_utils.dart';
import '../../Utils/storage_utils.dart';
import '../../Widgets/complere_register.dart';

class LoginController extends GetxController {
  RxBool isLogin = false.obs;
  RxBool isRegister = false.obs;
  RxBool isForgot = false.obs;
  RxBool getFingerprint = false.obs;
  Rx<TextEditingController> mobileController = (TextEditingController()).obs;
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String birthDay = 'تاریخ تولد';
  TextEditingController cityController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  FocusNode passwordNode = FocusNode();


  Jalali? birthDatePicked;


  final RequestsUtil requests = RequestsUtil();

  String refer = '';

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

  void submit() async {
    if (isForgot.value == true) {
      forgot();
    } else if (isRegister.value == true) {
      register();
    } else if (isLogin.value == true) {
      EasyLoading.show();
      ApiResult result = await requests.sendCode(
        mobileNumber: mobileController.value.text,
        code: codeController.text,
        login: true,
      );
      EasyLoading.dismiss();
      if (result.isDone) {
        print(result.data);
        // if (result.data['method'] == 'register') {
        StorageUtils.saveToken(result.data['token']);
        //   login();
        //   ///register
        // } else {
        login();
        //
        //   ///login
        // }
      } else {
        ViewUtils.showErrorDialog(
          result.data.toString(),
        );
      }
    } else {
      start();
    }
  }

  void register() async {
    if (codeController.text.length != 6) {
      ViewUtils.showErrorDialog(
        "لطفا کد تایید را به صورت کامل وارد کنید (6 رقم)",
      );
      return;
    }

    bool isBack = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: CompleteRegister(
            mobile: mobileController.value.text,
            code: codeController.value.text,
            controller: this,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );

    if (isBack) {
      EasyLoading.show();
      ApiResult result = await requests.sendCode(
        login: false,
        mobileNumber: mobileController.value.text,
        code: codeController.text,
        name: nameController.text,
        birthday: '${birthDatePicked!.year}-${birthDatePicked!.month}-${birthDatePicked!.day}',
        address: addressController.text,
        city: cityController.text,
        gender: selectedGender,
        postalCode: postalCodeController.text,
      );
      EasyLoading.dismiss();
      if (result.isDone) {
        print(result.data);
        // if (result.data['method'] == 'register') {
          StorageUtils.saveToken(result.data['token']);
        //   login();
        //   ///register
        // } else {
        login();
        //
        //   ///login
        // }
      } else {
        ViewUtils.showErrorDialog(
          result.data.toString(),
        );
      }
    }
  }

  void login() async {
    if (codeController.text.length != 6) {
      ViewUtils.showErrorDialog(
        "لطفا کد تایید را به صورت کامل وارد کنید (6 رقم)",
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
    ApiResult result = await requests.getUser();
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
      mobileNumber: mobileController.value.text,
    );
    EasyLoading.dismiss();

    if (result.isDone) {
      if (result.data['type'] == 'login') {
        isLogin(true);
      } else {
        isRegister(true);
      }
    }

    // isLogin.value = result.data['status'] == 1;
    // if (isLogin.value) {
    //   passwordNode.requestFocus();
    // codeFocusNode.requestFocus();
    // }

    // isRegister.value =
    //     result.data['status'] == 0 || result.data['status'] == 'register';
    // if (isRegister.value == true) {
    //   codeFocusNode.requestFocus();
    //   // ViewUtils.showInfoDialog(
    //   //   result.data?['message'],
    //   // );
    // } else {
    //   ViewUtils.showErrorDialog(
    //     result.data?['message'],
    //   );
    // }
  }

  void forgotPassword() async {
    EasyLoading.show();
    // ApiResult result =
    //     await requests.forgotPassword(mobileController.value.text);
    // EasyLoading.dismiss();
    //
    // if (result.isDone) {
    //   isForgot.value = true;
    //   codeFocusNode.requestFocus();
    //   isLogin.value = false;
    //   isRegister.value = false;
    // } else {
    //   ViewUtils.showErrorDialog(
    //     result.data['message'],
    //   );
    // }
  }

  void forgot() async {
    EasyLoading.show();
    // ApiResult result = await requests.forgotPasswordConfirm(
    //   mobileController.value.text,
    //   codeController.text,
    // );
    // EasyLoading.dismiss();
    //
    // if (result.isDone) {
    //   ViewUtils.showSuccessDialog(
    //     "رمز عبور جدید شما: ${codeController.text}",
    //   );
    //   // PrefHelpers.setCustomerId(result.data['customerId'].toString());
    //   // PrefHelpers.setMobile(this.mobileController.value.text.toString());
    //   // PrefHelpers.setCustomerIdBackup(
    //   //   result.data['customerId'].toString(),
    //   // );
    //   Globals.userStream
    //       .changeUser(UserModel.fromJson(result.data['customerData']));
    //
    //   Future.delayed(const Duration(seconds: 2), () {
    //     toMainPage();
    //   });
    // } else {
    //   ViewUtils.showErrorDialog(
    //     result.data['message'],
    //   );
  }

  void changeRefer(String s) {
    refer = s;
  }

  void toMainPage() async {
    ViewUtils.showSuccessDialog(
      "با موفقیت وارد شدید",
    );
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(
        RoutingUtils.main.name,
      );
    });
  }

  void openDatePicker() async {
    birthDatePicked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 1),
      lastDate: Jalali(1450, 9),
    );

    birthDay = birthDatePicked!.formatFullDate();
    update(['birthDay']);
  }


  String selectedGender = 'male';

  void changeGender({required String value}) {
    selectedGender = value;
    update(['gender']);
  }



}
