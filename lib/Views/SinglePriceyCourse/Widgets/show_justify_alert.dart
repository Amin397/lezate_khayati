import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/color_utils.dart';

class ShowJustifyAlert extends StatelessWidget {
  const ShowJustifyAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: Get.height * .25,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: radiusAll10,
          color: Colors.white,
        ),
        padding: paddingAll10,
        child: Column(
          children: [
            Text(
              'برای خرید دوره ابتدا باید با شماره های زیر تماس بگیرید و بعد از صحبت با مشاوران ما\nقادر به خرید دوره خواهید بود',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorUtils.textColor,
                fontSize: 14.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'شماره تماس :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorUtils.textColor,
                    fontSize: 14.0,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final LaunchUri = Uri(
                      scheme: 'tel',
                      path: '026-34612532',
                    );
                    await launchUrl(LaunchUri);
                  },
                  child: Text(
                    ' 026-34612532 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.blue,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () async {
                //     final LaunchUri = Uri(
                //       scheme: 'tel',
                //       path: '09125787206',
                //     );
                //     await launchUrl(LaunchUri);
                //   },
                //   child: Text(
                //     ' 09125787206',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: ColorUtils.blue,
                //       fontSize: 14.0,
                //     ),
                //   ),
                // ),
              ],
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      height: Get.height * .05,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: ColorUtils.orange,
                        borderRadius: radiusAll8,
                      ),
                      child: Center(
                        child: AutoSizeText(
                          'فهمیدم',
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
      ),
    );
  }
}
