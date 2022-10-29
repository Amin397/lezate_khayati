import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

// import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../Utils/Consts.dart';

class ShowSetRateModal extends StatelessWidget {
  ShowSetRateModal({Key? key, this.rate}) : super(key: key);
  double? rate;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Container(
        width: Get.width,
        height: Get.height * .25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.clear,
                ),
              ),
            ),
            Text(
              'لطفا امتیاز دهید',
              style: TextStyle(
                color: ColorUtils.textColor,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),

            // SmoothStarRating(
            //   allowHalfRating: true,
            //   onRated: (v) {
            //     rate = v;
            //   },
            //   starCount: 5,
            //   rating: rate,
            //   size: 40.0,
            //   isReadOnly: false,
            //   // fullRatedIconData: Icons.blur_off,
            //   // halfRatedIconData: Icons.blur_on,
            //   color: Colors.yellow.shade700,
            //   borderColor: Colors.yellow,
            //   spacing: 0.0,
            // ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      Get.back(
                        result: rate,
                      );
                    },
                    child: Container(
                      margin: paddingAll8,
                      height: Get.height * .05,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: ColorUtils.orange,
                        borderRadius: radiusAll8,
                      ),
                      child: Center(
                        child: AutoSizeText(
                          'ثبت امتیاز',
                          maxLines: 1,
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
