import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lottie/lottie.dart';

class BuildExitAlert extends StatelessWidget {
  const BuildExitAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: Get.height * .3,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusAll10,
        ),
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/exit.json',
              height: Get.height * .2,
              width: Get.height * .2,
            ),
            SizedBox(
              height: Get.height * .03,
            ),
            _buildButtons()
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Expanded(
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: paddingAll8,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Get.back(
                    result: false,
                  );
                },
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: radiusAll8,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      'انصراف',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Get.width * .03,
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Get.back(
                    result: true,
                  );
                },
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: radiusAll8,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      'خروج',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
