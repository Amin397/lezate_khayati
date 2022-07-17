import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';

class SplashController extends GetxController {
  final RxBool isLoaded = false.obs;


  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAndToNamed(
        RoutingUtils.login.name,
      );
    });
    super.onInit();
  }
}
