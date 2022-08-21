import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lottie/lottie.dart';

class BuildInviteAlert extends StatelessWidget {
  const BuildInviteAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return false;
      },
      child: Container(
        width: Get.width,
        height: Get.height * .3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusAll10,
        ),
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: Get.height * .07,
              padding: paddingAll10,
              child: Center(
                child: AutoSizeText(
                  'شما به ویدئو کنفرانس دعوت شده اید\nبرای وصل شدن به ویدئو کنفرانس دکمه ی اتصال را لمس کنید',
                  maxLines: 3,
                  maxFontSize: 18.0,
                  minFontSize: 12.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            Lottie.asset(
              'assets/animations/startLive.json',
              height: Get.height * .15,
              width: Get.height * .15,
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                margin: paddingAll10,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Get.back(result: false);
                        },
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: radiusAll10,
                            color: Colors.grey.withOpacity(.7),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              'انصراف',
                              maxFontSize: 18.0,
                              minFontSize: 12.0,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Get.back(result: true);
                        },
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.green.shade800,
                            borderRadius: radiusAll10,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: 5.0,
                                spreadRadius: 3.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: AutoSizeText(
                              'اتصال',
                              maxFontSize: 18.0,
                              minFontSize: 12.0,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
