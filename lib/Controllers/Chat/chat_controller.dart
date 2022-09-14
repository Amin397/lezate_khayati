import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/routing_utils.dart';
import 'package:lezate_khayati/Views/Lobby/lobby_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/Chat/chat_model.dart';
import '../../Views/Chat/Widget/start_video_confrance_modal.dart';
import '../../Views/Live/live_screen.dart';

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

  void goToSingleChat({required ChatRoomsModel item}) {
    Get.toNamed(RoutingUtils.singleChat.name, arguments: {
      'id': item.id,
      'title': item.data!.name,
    });
  }

  void goToLive() async {
    int startLive = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: StartVideoConferenceModal(),
      ),
    );


    await [Permission.camera, Permission.microphone].request();
    if (startLive == 1) {
      liveRequest();
    } else if(startLive == 2){
      joinToLive();
      // joinToLive();
    }
  }

  void liveRequest() async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.startLive();
    EasyLoading.dismiss();

    if (result.isDone) {
      print(result.data['live_id']);
      Get.to(()=>TypedVideoRoomV2Unified(liveId:result.data['live_id']));
      // Get.toNamed(
      //   RoutingUtils.live.name,
      //   arguments: {
      //     'liveId':result.data['live_id'],
      //   }
      // );
    }
  }

  void joinToLive() async{
    EasyLoading.show();
    print('hello requestteeed');
    ApiResult result = await RequestsUtil.instance.joinToLive();
    EasyLoading.dismiss();
    if(result.isDone){
      Get.toNamed(
          RoutingUtils.joinLive.name,
          arguments: {
            'liveId':Globals.liveStream.liveId,
          }
      );
      // Get.to(()=>LobbyPage(broadCast: false,));
    }
  }
}
