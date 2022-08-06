import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Profile/profile_controller.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

class BuildProfileWidget extends StatelessWidget {
  const BuildProfileWidget({Key? key, required this.controller})
      : super(key: key);

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radiusAll10,
      ),
      child: Row(
        children: [
          _buildAvatar(),
          _buildNameAndPhone(),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: (){
                controller.exit();
              },
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                padding: paddingSymmetricH8,
                child: Center(
                  child: Container(
                    width: double.maxFinite,
                    height: Get.height * .04,
                    decoration: BoxDecoration(
                      color: ColorUtils.red,
                      borderRadius: radiusAll6
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'خروج',
                        maxLines: 1,
                        maxFontSize: 16.0,
                        minFontSize: 12.0,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Flexible(
      flex: 1,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
          border: Border.all(
            color: Colors.grey.shade800,
            width: 3.0,
          ),
        ),
        margin: paddingAll6,
        child: Center(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndPhone() {
    return StreamBuilder(
      stream: Globals.userStream.getStream,
      builder: (x, c)=>Flexible(
        flex: 2,
        child: Container(
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
                    alignment: Alignment.bottomRight,
                    child: AutoSizeText(
                      Globals.userStream.user!.name!,
                      maxFontSize: 20.0,
                      maxLines: 1,
                      minFontSize: 14.0,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.0,),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AutoSizeText(
                      Globals.userStream.user!.mobile!,

                      maxFontSize: 16.0,
                      maxLines: 1,
                      minFontSize: 10.0,
                      style: TextStyle(
                        color: ColorUtils.textColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
