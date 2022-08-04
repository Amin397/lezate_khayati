import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Utils/Api/project_request_utils.dart';

class SingleBookController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;
  late final BooksModel model;

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
    ApiResult result = await RequestsUtil.instance.singleBook(
      id: id.toString(),
    );
    if(result.isDone){
      model = BooksModel.fromJson(result.data);
      isLoaded(true);
    }
  }
}
