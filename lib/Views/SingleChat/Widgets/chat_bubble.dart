import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Chat/messages_model.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

import '../../../Plugins/get/get.dart';
import '../../../Utils/color_utils.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    this.model,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final MessagesModel? model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment:
            (isCurrentUser) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          (!isCurrentUser) ? _buildUserImage() : SizedBox(),
          Padding(
            // asymmetric padding
            padding: EdgeInsets.fromLTRB(
              isCurrentUser ? Get.width * .2 : Get.width * .01,
              4,
              isCurrentUser ? Get.width * .01 : Get.width * .2,
              4,
            ),
            child: Align(
              // align the child within the container
              alignment:
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
              child: DecoratedBox(
                // chat bubble decoration
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
                child: buildText(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildText() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
              color: isCurrentUser ? Colors.white : Colors.black87,
            ),
      ),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          if (text.trim().isNotEmpty) ...[
            SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildUserImage() {
    return Padding(
      padding: paddingAll4,
      child: Container(
        width: Get.width * .1,
        height: Get.width * .1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: (model!.user!.avatar is String)
            ? Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    model!.user!.avatar!,
                  ),
                  placeholder: AssetImage(
                    'assets/img/placeHolder.jpg',
                  ),
                ),
              ),
      ),
    );
  }
}
