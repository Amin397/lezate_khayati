import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Models/Home/products_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Api/project_request_utils.dart';

class SingleProductController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;

  late final ProductsModel model;

  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    index = Get.arguments['index'];
    id = Get.arguments['id'];
    image = Get.arguments['image'];
    name = Get.arguments['name'];

    getData();
    super.onInit();
  }

  void getData() async {
    ApiResult result = await RequestsUtil.instance.singleProduct(
      productId: id.toString(),
    );
    if (result.isDone) {
      model = ProductsModel.fromJson(result.data);
      isLoaded(true);
    }
  }

  void buyProduct() async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.buyProduct(
      productId: model.id.toString(),
    );

    if(result.status == 200){

      await launchUrl(Uri.parse('https://seeuland.com/api/products/buy/$id/${Globals.userStream.user!.id}'));

    }

    EasyLoading.dismiss();



  }
}
