import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Models/Chat/messages_model.dart';
import '../../Utils/logic_utils.dart';
import '../../Views/SingleChat/Widgets/build_show_image_widget.dart';

class SingleChatController extends GetxController
    with SingleGetTickerProviderMixin {
  RxBool isLoaded = false.obs;

  List<MessageModel> chats = [];
  final ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  final Record record = Record();

  final RxBool isRecording = false.obs;
  final RxBool isRecorded = false.obs;
  final RxBool showSendButton = false.obs;
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
    getData(notification: false);
    super.onInit();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('MMMMMMMMMMMMMMMMMMMMMMMM');
      getData(notification: true);
      // showSimpleNotification(
      //     Text("jooon"),
      //     background: Colors.green,
      //     contentPadding: paddingAll10
      // );
    });

    record.hasPermission().then((value) {});
  }

  void getData({required bool notification}) async {
    ApiResult result = await RequestsUtil.instance.getMessages(
      chatId: id.toString(),
    );

    if (result.isDone) {
      if (notification) {
        chats.clear();
        chats = MessageModel.listFromJson(result.data);
        isLoaded(false);
        isLoaded(true);
      } else {
        chats = MessageModel.listFromJson(result.data);
        isLoaded(true);
      }
      Future.delayed(Duration(milliseconds: 500), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void sendMessage({File? file}) async {
    MessageModel message;

    if (isRecorded.isTrue) {
      message = MessageModel(
        body: messageController.text,
        isMe: true,
        userId: Globals.userStream.user!.id.toString(),
        user: User(
          name: Globals.userStream.user!.name,
          id: Globals.userStream.user!.id,
          avatar: Globals.userStream.user!.avatar,
        ),
        files: Files(
          type: 'voice',
          file: file,
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
        file: file,
        type: 'voice',
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

      deleteVoice();
    } else {
      if (file is File) {
        message = MessageModel(
          body: messageController.text,
          isMe: true,
          userId: Globals.userStream.user!.id.toString(),
          user: User(
            name: Globals.userStream.user!.name,
            id: Globals.userStream.user!.id,
            avatar: Globals.userStream.user!.avatar,
          ),
          files: Files(
            type: 'image',
            file: file,
          ),
        );
      } else {
        message = MessageModel(
          body: messageController.text,
          isMe: true,
          userId: Globals.userStream.user!.id.toString(),
          user: User(
            name: Globals.userStream.user!.name,
            id: Globals.userStream.user!.id,
            avatar: Globals.userStream.user!.avatar,
          ),
        );
      }
      animationController
        ..duration = const Duration(milliseconds: 1800)
        ..forward();
      Future.delayed(const Duration(milliseconds: 1800), () {
        animationController.reset();
      });

      chats.add(message);

      if (file is File) {
        ApiResult result = await RequestsUtil.instance.sendMessage(
          chatId: id.toString(),
          message: messageController.text,
          file: file,
          type: 'image',
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
      } else {
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
      }
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

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      bool isVideo = false;

      switch (file.path.split('.').last) {
        case 'png':
          {
            print('png');
            break;
          }
        case 'jpeg':
          {
            print('jpeg');
            break;
          }
        case 'mp4':
          {
            file = await getThumb(filePath: file.path);
            isVideo = true;
            print('mp4');
            break;
          }
        default:
          {
            print(file.path.split('.').last.toString());
            break;
          }
      }

      bool isSend = await showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (BuildContext context) => BuildShowImageWidget(
          controller: this,
          file: file,
          isVideo: isVideo,
        ),
      );

      // bool isSend = await showDialog(
      //   context: Get.context!,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) => AlertDialog(
      //     contentPadding: EdgeInsets.zero,
      //     backgroundColor: Colors.transparent,
      //     content: BuildShowImageWidget(
      //       controller: this,
      //       file: file,
      //       isVideo: isVideo,
      //     ),
      //   ),
      // );

      if (isSend) {
        sendMessage(
          file: file,
        );
      }
    }
  }

  String voicePath = "";
  String voiceShowTime = "";
  DateTime? voiceTime;

  void start() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    if (await record.hasPermission()) {
      // Start recording
      print('start');
      if (!(await record.isRecording())) {
        voicePath = tempPath + "/voice_${DateTime.now()}.m4a";
        await record.start(
          path: voicePath,
        );
        isRecording.value = true;
        voiceTime = DateTime.now();
      } else {
        await record.stop();
        isRecording.value = false;
      }
    }
  }

  void stop() async {
    if (await record.isRecording()) {
      await record.stop();
      voiceShowTime = LogicUtils.durationToMinHour(
        DateTime.now().difference(voiceTime!),
      );

      isRecording.value = false;
      isRecorded.value = true;
    }
  }

  Future<File> getThumb({required String filePath}) async {
    var amin = await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.WEBP,
      quality: 100,
    );
    return File.fromRawPath(amin!);
  }

  void switchToVoice() {
    isRecorded(true);
    update(['switchToVoice']);
  }

  void deleteVoice() {
    isRecorded(false);
    voicePath = '';
  }
}
