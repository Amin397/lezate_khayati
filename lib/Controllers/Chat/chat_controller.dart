import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/Chat/chat_model.dart';

class ChatController extends GetxController {
  TextEditingController searchTextController = TextEditingController();

  List<ChatRoomsModel> chatList = [];

  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    getChatRooms();
    super.onInit();
  }

  void getChatRooms() async {
    ApiResult result = await RequestsUtil.instance.getChatRooms();

    if (result.isDone) {
      chatList = ChatRoomsModel.listFromJson(result.data);
      isLoaded(true);
    }
  }

  void search({required String text}) {
    if (text.isEmpty) {
      chatList.forEach((element) {
        element.visible(true);
      });
    } else {
      chatList.forEach((element) {
        if (!element.data!.name!.contains(text)) {
          element.visible(false);
        } else {
          element.visible(true);
        }
      });
    }
  }
}
