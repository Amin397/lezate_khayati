import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Chat/single_chat_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class BuildShowImageWidget extends StatelessWidget {
  const BuildShowImageWidget(
      {Key? key,
      required this.file,
      required this.isVideo,
      required this.controller})
      : super(key: key);

  final File file;
  final bool isVideo;
  final SingleChatController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radiusAll10,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Get.back(
                  result: false,
                );
              },
              icon: Icon(Icons.clear),
            ),
          ),
          _buildImage(),
          Container(
            width: Get.width,
            height: Get.height * .1,
            padding: paddingAll10,
            child: TextField(
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
              ),
            ),
          ),
          _buildSendButton()
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: Get.width,
      height: Get.height * .45,
      margin: paddingAll10,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
      ),
      child: Stack(
        children: [
          Container(
            margin: paddingAll10,
            width: Get.width,
            height: Get.height * .45,
            child: ClipRRect(
              borderRadius: radiusAll10,
              child: Image(
                image: FileImage(
                  file,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          (isVideo)
              ? Container(
                  margin: paddingAll10,
                  width: Get.width,
                  height: Get.height * .45,
                  decoration: BoxDecoration(
                    borderRadius: radiusAll10,
                    color: Colors.black38,
                  ),
                )
              : SizedBox(),
          (isVideo)
              ? Center(
                  child: Icon(
                    Icons.videocam,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.back(
            result: true,
          );
        },
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: paddingAll10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Get.width,
              height: Get.height * .05,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: radiusAll8,
              ),
              child: Center(
                child: AutoSizeText(
                  'ارسال',
                  maxLines: 1,
                  maxFontSize: 18.0,
                  minFontSize: 12.0,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
