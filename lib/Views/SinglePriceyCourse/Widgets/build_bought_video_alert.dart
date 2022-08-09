import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';
import 'package:lottie/lottie.dart';

class BuildBoughtVideoAlert extends StatelessWidget {
  const BuildBoughtVideoAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .4,
      width: Get.width,
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
                Get.back(result: false);
              },
              icon: Icon(Icons.clear),
            ),
          ),
          Lottie.asset(
            'assets/animations/cart.json',
            height: Get.height * .2,
            width: Get.height * .2,
          ),
          Text(
            'خرید دوره',
            style: TextStyle(
              color: Colors.grey.shade700,

            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: (){
                    Get.back(result: true);
                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height * .05,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: radiusAll10,
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'رفتن به درگاه پرداخت',
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
              ),
            ),
          )

        ],
      ),
    );
  }
}
