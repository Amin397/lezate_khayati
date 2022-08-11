import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Utils/storage_utils.dart';

import '../../Globals/Globals.dart';
import '../../Models/user_model.dart';
import '../../Plugins/neu/flutter_neumorphic.dart';
import '../../Utils/Api/project_request_utils.dart';
import '../../Utils/view_utils.dart';

class SplashController extends GetxController {
  final RequestsUtil requests = RequestsUtil();

  @override
  void onInit() {
    getData();

    super.onInit();
  }

  @override
  void dispose() {
    onDelete();
    super.dispose();
  }

  void getData() async {
    StorageUtils.getToken().then((value) async {
      if (value.length > 10) {
        ApiResult result = await requests.getUser();
        if (result.isDone) {
          FocusScope.of(context).requestFocus(FocusNode());

          Globals.userStream.changeUser(UserModel.fromJson(
            result.data,
          ));

          FirebaseMessaging.instance.getToken().then((value) {
            print(value);
            sendToken(
              token: value!,
            );
          });


        } else {
          ViewUtils.showErrorDialog(
            result.data.toString(),
          );
        }
      } else {
        print('nist');
        Future.delayed(Duration(seconds: 3), () {
          Get.offAndToNamed(
            RoutingUtils.login.name,
          );
        });
      }
    });
  }

  void sendToken({required String token}) async {
    ApiResult result = await RequestsUtil.instance.sendToken(
      token: token,
    );

    if (result.isDone) {
      Future.delayed(Duration(seconds: 3), () {
        Get.offAndToNamed(
          RoutingUtils.main.name,
        );
      });
    }
  }
}
