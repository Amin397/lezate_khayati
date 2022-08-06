import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/MyClass/my_courses_model.dart';

class MyClassController extends GetxController{

  List<MyCourseModel> courseList = [];
  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async{
    ApiResult result = await RequestsUtil.instance.getUserClass();
    if(result.isDone){
      courseList = MyCourseModel.listFromJson(result.data['courses']);
      isLoaded(true);
    }
  }
}