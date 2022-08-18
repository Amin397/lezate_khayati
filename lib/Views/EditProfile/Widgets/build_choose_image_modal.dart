import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lezate_khayati/Controllers/EditProfile/edit_profile_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class BuildChooseImageModal extends StatelessWidget {
  const BuildChooseImageModal({Key? key, required this.controller})
      : super(key: key);
  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: (controller.avatar is File) ? Get.height * .35 : Get.height * .25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Get.back(
                  result: 0,
                );
              },
            ),
          ),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Expanded(
        child: Container(
          padding: paddingAll8,
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: [
              _buildImageSource(camera: false),
              Divider(),
              _buildImageSource(camera: true),
              (controller.avatar is XFile) ? Divider() : SizedBox(),
              (controller.avatar is XFile)
                  ? Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          Get.back(result: 3);
                        },
                        child: Container(
                          height: double.maxFinite,
                          width: Get.width * .8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: radiusAll10,
                          ),
                          child: Center(
                            child: AutoSizeText(
                              'حذف عکس ',
                              maxFontSize: 18.0,
                              maxLines: 1,
                              minFontSize: 12.0,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSource({required bool camera}) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: () {
          if (camera) {
            Get.back(result: 1);
          } else {
            Get.back(result: 2);
          }
        },
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    (camera) ? Icons.camera_alt_outlined : Icons.image_outlined,
                    color: Colors.blue.shade700,
                    size: 40.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    (camera) ? 'باز کردن دوربین' : 'باز کردن گالری',
                    style: TextStyle(
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_right_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
