import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/Chat/single_chat_controller.dart';
import '../../Plugins/voice/src/voice_message.dart';
import 'Widgets/chat_bubble.dart';

class SingleChatScreen extends StatelessWidget {
  SingleChatScreen({Key? key}) : super(key: key);

  final SingleChatController controller = Get.put(SingleChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/img/placeHolder.jpg',
                ),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          buildPage(),
        ],
      ),
    );
  }

  Widget _buildMessageField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: paddingAll8,
          // height: Get.height * .08,
          width: Get.width,
          child: Obx(() => (controller.isRecorded.isTrue)
              ? Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.maxFinite,
                        height: Get.height * .08,
                        child: VoiceMessage(
                          audioFile: File(controller.voicePath),
                          isLocale: true,
                          played: false,
                          me: true,
                          onPlay: () {},
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.deleteVoice();
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                    GetBuilder(
                      init: controller,
                      id: 'resetSendMessage',
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          if (controller.messageController.text.isNotEmpty) {
                            controller.sendMessage();
                          } else if (controller.isRecorded.isTrue) {
                            controller.sendMessage(
                              file: File(controller.voicePath),
                            );
                          }
                        },
                        child: Lottie.asset(
                          'assets/animations/send.json',
                          height: Get.width * .15,
                          width: Get.width * .15,
                          controller: controller.animationController,
                          // repeat: false,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        constraints: BoxConstraints(
                          maxHeight: Get.height * .15,
                        ),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // boxShadow: ViewUtils.shadow(
                          //   offset: const Offset(0.0, 0.0),
                          // ),
                          borderRadius: radiusAll10,
                        ),
                        duration: const Duration(milliseconds: 270),
                        child: TextField(
                          onTap: () {
                            controller.scrollToDown();
                          },
                          controller: controller.messageController,
                          maxLines: 10,
                          minLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: radiusAll10,
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: radiusAll10,
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                            ),
                            hintText: 'متن پیام',
                            hintStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                            // suffixIcon: IconButton(
                            //   onPressed: () {
                            //     controller.pickFile();
                            //   },
                            //   icon: Icon(
                            //     Icons.attach_file,
                            //     color: Colors.grey.shade700,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Get.height * .01,
                      ),
                      child: IconButton(
                        onPressed: () {
                          controller.pickFile();
                        },
                        icon: Icon(
                          Icons.attach_file,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: (controller.isRecording.isTrue)?100.0:30.0,
                      width: (controller.isRecording.isTrue)?100.0:30.0,
                      // color: Colors.red,
                      margin: EdgeInsets.symmetric(vertical: Get.height * .02),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          (controller.isRecording.isTrue)
                              ? Center(
                                child: Container(
                                  child: Lottie.asset(
                                      'assets/animations/voiceWave.json',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                ),
                              )
                              : SizedBox(),
                          Center(
                            child: GestureDetector(
                              onLongPressStart: (LongPressStartDetails s) {
                                print('start');
                                controller.start();
                              },
                              onLongPressEnd: (LongPressEndDetails s) {
                                print('end');
                                controller.stop();
                              },
                              child: Icon(
                                Icons.mic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GetBuilder(
                      init: controller,
                      id: 'resetSendMessage',
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          if (controller.messageController.text.isNotEmpty) {
                            controller.sendMessage();
                          }
                        },
                        child: Lottie.asset(
                          'assets/animations/send.json',
                          height: Get.width * .15,
                          width: Get.width * .15,
                          controller: controller.animationController,
                          // repeat: false,
                        ),
                      ),
                    ),
                  ],
                )),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        controller.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget buildPage() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: GetBuilder(
              init: controller,
              id: 'refreshChats',
              builder: (ctx) => Obx(
                () => (controller.isLoaded.isTrue)
                    ? SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: controller.scrollController,
                          itemCount: controller.chats.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ChatBubble(
                            file: controller.chats[index].files!.file,
                            model: controller.chats[index],
                            isCurrentUser: controller.chats[index].isMe!,
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
          _buildMessageField(),
        ],
      ),
    );
  }
}
