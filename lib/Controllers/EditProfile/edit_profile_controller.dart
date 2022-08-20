import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Models/user_model.dart';
import '../../Utils/storage_utils.dart';
import '../../Utils/view_utils.dart';
import '../../Views/EditProfile/Widgets/build_choose_image_modal.dart';

class EditProfileController extends GetxController {
  XFile? avatar;

  final ImagePicker picker = ImagePicker();

  Jalali? birthDatePicked;
  String birthDay = 'تاریخ تولد';

  TextEditingController nameController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  void pickImage() async {
    int chooseImage = await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) => BuildChooseImageModal(
        controller: this,
      ),
    );

    switch (chooseImage) {
      case 0:
        {
          break;
        }
      case 1:
        {
          getImage(
            source: ImageSource.camera,
          );
          break;
        }
      case 2:
        {
          getImage(
            source: ImageSource.gallery,
          );
          break;
        }
      default:
        {
          avatar = null;
          update(['updateAvatar']);
          break;
        }
    }
  }

  void openDatePicker() async {
    birthDatePicked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali(
        int.parse(Globals.userStream.user!.birthday!.split('-').first),
        int.parse(Globals.userStream.user!.birthday!.split('-')[1]),
      ),
      firstDate: Jalali(1300, 1),
      lastDate: Jalali(1450, 9),
    );

    birthDay = birthDatePicked!.formatFullDate();
    update(['birthDay']);
  }

  void getImage({required ImageSource source}) async {
    avatar = await picker.pickImage(
      source: source,
    );

    if (avatar != null) {
      update(['updateAvatar']);
    }
  }

  String selectedGender = 'male';

  void changeGender({required String value}) {
    selectedGender = value;
    update(['gender']);
  }

  void initData() {
    nameController.text = Globals.userStream.user!.name!;
    cityController.text = Globals.userStream.user!.city!;
    addressController.text = Globals.userStream.user!.address!;
    postalCodeController.text = Globals.userStream.user!.postalCode!;
    birthDay = Globals.userStream.user!.birthday!.replaceAll('-', '/');
    birthDatePicked = Jalali(
      int.parse(Globals.userStream.user!.birthday!.split('-').first),
      int.parse(Globals.userStream.user!.birthday!.split('-')[1]),
    );
    changeGender(
      value: Globals.userStream.user!.gender!,
    );
  }

  void save()async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.updateProfile(
      postalCode: postalCodeController.text,
      gender: selectedGender,
      city: cityController.text,
      address: addressController.text,
      name: nameController.text,
      birthDay: '${birthDatePicked!.year}-${birthDatePicked!.month}-${birthDatePicked!.day}',
      avatarPath: (avatar is XFile)?avatar!.path:null,
    );

    if(result.isDone){
      getUserData();
    }
  }


  void getUserData()async{
    ApiResult result = await RequestsUtil.instance.getUser();
    EasyLoading.dismiss();
    if (result.isDone) {
      ViewUtils.showSuccessDialog(
        result.data['message'],
      );
      Globals.userStream.changeUser(UserModel.fromJson(
        result.data,
      ));
    } else {
      ViewUtils.showErrorDialog(
        result.data.toString(),
      );
    }
  }
}
