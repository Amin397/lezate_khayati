import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

class MyClassController extends GetxController{




  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async{
    ApiResult result = await RequestsUtil.instance.getUserClass();
  }
}