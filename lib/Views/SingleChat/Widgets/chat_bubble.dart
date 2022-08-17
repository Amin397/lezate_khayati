import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Chat/messages_model.dart';

import '../../../Plugins/get/get.dart';
import '../../../Plugins/voice/src/voice_message.dart';
import '../../../Utils/color_utils.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    // this.text,
    required this.isCurrentUser,
    this.model,
    this.file,
  }) : super(key: key);

  // final String? text;
  final bool isCurrentUser;
  final MessageModel? model;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 8.0,
      ),
      width: Get.width,
      // height: (model!.files!.type! == 'voice')
      //     ? Get.height * .125
      //     : Get.height * .31,
      child: Row(
        mainAxisAlignment:
            !isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isCurrentUser) ? SizedBox() : _buildUserImage(),
          SizedBox(
            width: 6.0,
          ),
          Container(
            // chat bubble decoration
            constraints: BoxConstraints(
              maxHeight: Get.height * .305,
              maxWidth: Get.width * .8,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser ? ColorUtils.textPurple : Colors.grey[300],
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
      child: Text(
        model!.body!,
        style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
              color: isCurrentUser ? Colors.white : Colors.black87,
            ),
      ),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: EdgeInsets.all(model!.files!.type == 'voice' ? 0 : 8),
      child: Column(
        children: [
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
            Text(
              model!.body ?? '',
              style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
            ),
          ]
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
}
