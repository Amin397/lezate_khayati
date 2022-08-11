import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/Chat/single_chat_controller.dart';
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
              color: Colors.white.withOpacity(0.8),
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
          child: Row(
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
                    onTap: (){
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
                    ),
                  ),
                ),
              ),
              GetBuilder(
                init: controller,
                id: 'resetSendMessage',
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    controller.sendMessage();
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
          ),
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
                            text: controller.chats[index].body!,
                            model: controller.chats[index],
                            isCurrentUser: controller.chats[index].isMe!,
                          ),
                        ),
                        // child: SingleChildScrollView(
                        //   controller: controller.scrollController,
                        //   child: Column(
                        //     children: controller.isLoaded.isTrue ? [] : buildChats(),
                        //   ),
                        // ),
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
