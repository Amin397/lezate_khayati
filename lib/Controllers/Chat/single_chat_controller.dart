import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

import '../../Models/Chat/messages_model.dart';

class SingleChatController extends GetxController
    with SingleGetTickerProviderMixin {
  RxBool isLoaded = false.obs;

  List<MessagesModel> chats = [];
  final ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  late final AnimationController animationController;

  late final int id;
  late final String title;

  @override
  void onInit() {
    id = Get.arguments['id'];
    title = Get.arguments['title'];
    animationController = AnimationController(
      vsync: this,
    );
    getData();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('MMMMMMMMMMMMMMMMMMMMMMMM');
        print(message.data);
        print('MMMMMMMMMMMMMMMMMMMMMMMM');
      }
    });

    super.onInit();
  }

  void getData() async {
    ApiResult result = await RequestsUtil.instance.getMessages(
      chatId: id.toString(),
    );

    if (result.isDone) {
      chats = MessagesModel.listFromJson(result.data);

      isLoaded(true);
    }

    Future.delayed(Duration(milliseconds: 500), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 300,
        duration: const Duration(
          milliseconds: 600,
        ),
        curve: Curves.easeInOut,
      );
    });
    refresh();
  }

  void sendMessage() async {
    MessagesModel message = MessagesModel(
      body: messageController.text,
      isMe: true,
      userId: Globals.userStream.user!.id.toString(),
      user: User(
        name: Globals.userStream.user!.name,
        id: Globals.userStream.user!.id,
        avatar: Globals.userStream.user!.avatar,
      ),
    );
    animationController
      ..duration = const Duration(milliseconds: 1800)
      ..forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      animationController.reset();
    });

    chats.add(message);

    ApiResult result = await RequestsUtil.instance.sendMessage(
      chatId: id.toString(),
      message: messageController.text,
    );
    messageController.clear();

    if (result.isDone) {
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(
            milliseconds: 600,
          ),
          curve: Curves.easeInOut,
        );
      });
    } else {
      ViewUtils.showErrorDialog(
        'ارسال با مشکل مواجه شد',
      );
      Future.delayed(Duration(seconds: 1), () {
        chats.remove(message);
      });
    }

    update(['refreshChats']);
  }

  void scrollToDown() {
    Future.delayed(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 50,
        duration: const Duration(
          milliseconds: 600,
        ),
        curve: Curves.easeInOut,
      );
    });
  }
}
