import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Chat/messages_model.dart';

import '../../../Controllers/Chat/single_chat_controller.dart';
import '../../../Plugins/get/get.dart';
import '../../../Plugins/voice/src/voice_message.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/color_utils.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key? key,
    // this.text,
    required this.isCurrentUser,
    this.model,
    this.file,
  }) : super(key: key);

  final SingleChatController controller = Get.find();

  // final String? text;
  final bool isCurrentUser;
  final MessageModel? model;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 1) {
          controller.replyMessage(
            model: model,
          );
        }
      },
      child: SlideTransition(
        position: model!.animation!,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          width: Get.width,
          // height: (model!.files!.type! == 'voice')
          //     ? Get.height * .125
          //     : Get.height * .31,
          child: Row(
            mainAxisAlignment: !isCurrentUser
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (isCurrentUser) ? SizedBox() : _buildUserImage(),
              SizedBox(
                width: 6.0,
              ),
              Container(
                // chat bubble decoration
                constraints: BoxConstraints(
                  // maxHeight: Get.height * .305,
                  maxWidth: Get.width * .8,
                ),
                decoration: BoxDecoration(
                  color:
                      isCurrentUser ? ColorUtils.textPurple : Colors.grey[300],
                  borderRadius: isCurrentUser
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        ),
                ),
                child: buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    if (model!.files is Files) {
      switch (model!.files!.type) {
        case 'image':
        case 'voice':
          return buildImage();
      }
    }
    return buildText();
  }

  Widget buildText() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: (model!.isMe!)
          ? Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (model!.parent is ParentClass)
                      ? _buildReplyPart()
                      : SizedBox(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    model!.body!,
                    style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                          color: isCurrentUser ? Colors.white : Colors.black87,
                        ),
                  ),
                  (model!.isSend.isTrue)
                      ? Stack(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12.0,
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                          size: 14.0,
                        ),
                ],
              ),
            )
          : Text(
              model!.body!,
              style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
            ),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: EdgeInsets.all(model!.files!.type == 'voice' ? 6 : 8),
      child: Column(
        children: [
          (model!.parent is ParentClass) ? _buildReplyPart() : SizedBox(),
          SizedBox(
            height: 8.0,
          ),
          (!model!.isMe!)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model!.user!.name!,
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 8.0,
          ),
          buildInput(),
          if (model!.body is String) ...[
            SizedBox(
              height: 8,
            ),
            Align(
              alignment:
                  (model!.isMe!) ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                model!.body ?? '',
                style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                      color: isCurrentUser ? Colors.white : Colors.black87,
                    ),
              ),
            ),
          ],
          (model!.isMe!)
              ? (model!.isSend.isTrue)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            ),
                          )
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                        size: 14.0,
                      ),
                    )
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildInput() {
    Widget child = Container();
    print(model?.files!.input);
    if (file is File) {
      if (model!.files!.type == 'image') {
        child = Image.file(
          file!,
        );
      } else if (model!.files!.type == 'voice') {
        child = VoiceMessage(
          audioFile: file,
          isLocale: true,
          played: false,
          me: true,
          onPlay: () {},
        );
      }
    } else if (model!.files!.type is String) {
      if (model!.files!.type == 'image') {
        child = FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            model!.files!.input!,
          ),
          placeholder: AssetImage(
            'assets/img/placeHolder.jpg',
          ),
        );
        // child = Image.network(
        //   model!.files!.input!,
        // );
      } else if (model!.files!.type == 'voice') {
        child = VoiceMessage(
          audioSrc: model!.files!.input,
          isLocale: false,
          played: false,
          me: true,
          onPlay: () {},
        );
      }
    }
    return ClipRRect(
      child: child,
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  Widget _buildUserImage() {
    return Container(
      height: Get.width * .1,
      width: Get.width * .1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: (model!.user!.avatar is String)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  model!.user!.avatar!,
                ),
                placeholder: AssetImage(
                  'assets/img/placeHolder.jpg',
                ),
              ),
            )
          : Center(
              child: Icon(
                Icons.person,
              ),
            ),
    );
  }

  Widget _buildReplyPart() {
    return Container(
      height: Get.height * .1,
      constraints: BoxConstraints(
        maxWidth: Get.width * .8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.7),
        borderRadius: radiusAll10,
      ),
      padding: paddingAll6,
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * .02,
      ),
      child: Row(
        children: [
          Container(
            width: 6.0,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10.0),
              ),
            ),
          ),
          Container(
            width: Get.width * .65,
            height: double.maxFinite,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                if (model is MessageModel)
                  Container(
                    width: double.maxFinite,
                    height: Get.height * .02,
                    margin: EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          child: Text(
                            (model!.parent!.isMe!) ? 'شما' : model!.replyName!,
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     controller.clearReply();
                        //   },
                        //   child: Icon(
                        //     Icons.clear,
                        //     size: 20.0,
                        //     color: Colors.grey,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                if (model is MessageModel)
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      padding: paddingAll6,
                      child: (controller.chats
                              .singleWhere(
                                  (element) => element.id == model!.parent!.id)
                              .files is Files)
                          ? (controller.chats
                                      .singleWhere((element) =>
                                          element.id == model!.parent!.id)
                                      .files!
                                      .type ==
                                  'image')
                              ? Row(
                                  children: [
                                    Container(
                                      height: Get.width * .17,
                                      width: Get.width * .17,
                                      // margin: EdgeInsets.only(right: Get.width * .7),
                                      child: ClipRRect(
                                        borderRadius: radiusAll6,
                                        child: (controller.chats
                                                .singleWhere((element) =>
                                                    element.id ==
                                                    model!.parent!.id)
                                                .files!
                                                .input is String)
                                            ? Image(
                                                image: NetworkImage(
                                                  controller.chats
                                                      .singleWhere((element) =>
                                                          element.id ==
                                                          model!.parent!.id)
                                                      .files!
                                                      .input!,
                                                ),
                                                fit: BoxFit.fill,
                                              )
                                            : Image(
                                                image: FileImage(
                                                  model!.files!.file!,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    (model!.body is String)
                                        ? Expanded(
                                            child: Container(
                                              height: double.maxFinite,
                                              width: double.maxFinite,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  model!.body!,
                                                  maxLines: 2,
                                                  maxFontSize: 18.0,
                                                  minFontSize: 12.0,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                )
                              : (model!.files!.input is String)
                                  ? VoiceMessage(
                                      audioSrc: model!.files!.input!,
                                      isLocale: false,
                                      played: false,
                                      me: false,
                                      onPlay: () {},
                                    )
                                  : VoiceMessage(
                                      audioFile: model!.files!.file!,
                                      isLocale: true,
                                      played: false,
                                      me: false,
                                      onPlay: () {},
                                    )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                // model!.body!,
                                controller.chats
                                    .singleWhere((element) =>
                                        element.id == model!.parent!.id)
                                    .body!,
                                maxLines: 2,
                                maxFontSize: 18.0,
                                minFontSize: 12.0,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
