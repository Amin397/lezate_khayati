import 'package:get_storage/get_storage.dart';
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

  void getData() async{
    StorageUtils.getToken().then((value)async{
      if(value.length > 10){
        ApiResult result = await requests.getUser();
        if (result.isDone) {

          FocusScope.of(context).requestFocus(FocusNode());

          Globals.userStream.changeUser(UserModel.fromJson(
            result.data,
          ));

          Future.delayed(Duration(seconds: 3), () {
            Get.offAndToNamed(
              RoutingUtils.main.name,
            );
          });
        } else {
          ViewUtils.showErrorDialog(
            result.data.toString(),
          );
        }
      }else{
        print('nist');
        Future.delayed(Duration(seconds: 3), () {
          Get.offAndToNamed(
            RoutingUtils.login.name,
          );
        });

      }
    });
  }
}
