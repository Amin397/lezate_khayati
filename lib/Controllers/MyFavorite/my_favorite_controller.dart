import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

class MyFavoriteController extends GetxController{





  @override
  void onInit() {
    getFavorite(mode: 'post');
    super.onInit();
  }

  void getFavorite({required String mode})async {
    ApiResult result = await RequestsUtil.instance.getFavorites(
      mode:mode,
    );

    if(result.isDone){
      print(result.isDone);
    }
  }
}