import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Chat/chat_controller.dart';
import 'package:lezate_khayati/Models/Chat/chat_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Plugins/neu/src/widget/container.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class BuildChatItemWidget extends StatelessWidget {
  const BuildChatItemWidget(
      {Key? key,
      required this.index,
      required this.controller,
      required this.item})
      : super(key: key);

  final ChatRoomsModel item;
  final int index;
  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.goToSingleChat(
          item: item,
        );
      },
      child: Container(
        width: Get.width,
        height: Get.height * .1,
        margin: EdgeInsets.symmetric(
          horizontal: Get.width * .03,
          // vertical: Get.height * .01,
        ),
        child: Row(
          children: [
            _buildChatAvatar(),
            SizedBox(
              width: Get.width * .02,
            ),
            _buildChatBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatAvatar() {
    return Container(
      width: Get.width * .25,
      height: double.maxFinite,
      child: Center(
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(50),
            ),
            depth: 3,
            lightSource: LightSource.topLeft,
            color: Colors.grey[100],
          ),
          child: Container(
            height: double.maxFinite,
            width: Get.width * .2,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: paddingAll16,
            child: Image(
              image: AssetImage(
                'assets/img/chatAvatar.png',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    item.data!.name!,
                    maxLines: 1,
                    maxFontSize: 18.0,
                    minFontSize: 12.0,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xffE81D46),
                    ),
                  ),
                ),
              ),
            ),
            // Flexible(
            //   flex: 1,
            //   child: SizedBox(
            //     height: double.maxFinite,
            //     width: double.maxFinite,
            //     child: Align(
            //       alignment: Alignment.centerRight,
            //       child: AutoSizeText(
            //         item.lastMessage,
            //         maxLines: 1,
            //         maxFontSize: 14.0,
            //         minFontSize: 10.0,
            //         style: TextStyle(
            //           fontSize: 12.0,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
