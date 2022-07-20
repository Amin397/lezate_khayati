import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

class ViewUtils {
  static void showSuccessDialog(
    text, {
    String? title = 'عملیات موفق آمیز بود',
  }) {
    Get.snackbar(
      title ?? '',
      text ?? '',
      colorText: Colors.white.withOpacity(0.7),
      backgroundGradient: LinearGradient(
        colors: [
          ColorUtils.green.shade100,
          ColorUtils.green,
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Icons.done,
        color: ColorUtils.green,
        size: Get.height / 28,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showInfoDialog([
    String? text = "خطایی رخ داد",
    String? title = 'لطفا توجه کنید',
  ]) {
    Get.snackbar(
      title ?? '',
      text ?? '',
      backgroundGradient: LinearGradient(
        colors: [
          ColorUtils.yellow.withOpacity(0.4),
          ColorUtils.yellow,
        ],
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.information_circle_outline,
        size: Get.height / 28,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static List<BoxShadow> neoShadow() {
    return [
      // Shadow for top-left corner
      const BoxShadow(
        color: Colors.grey,
        offset: Offset(5, 5),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      // Shadow for bottom-right corner
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-5, -5),
        blurRadius: 10,
        spreadRadius: 4,
      ),
    ];
  }



  static void showErrorDialog([
    String? text = "خطایی رخ داد",
    String? title = "خطایی رخ داد",
    SnackPosition position = SnackPosition.BOTTOM,
  ]) {
    Get.snackbar(
      title ?? '',
      text ?? '',
      backgroundGradient: LinearGradient(
        colors: [
          ColorUtils.red.withOpacity(0.5),
          ColorUtils.red.withOpacity(0.8),
        ],
      ),
      colorText: Colors.white.withOpacity(0.7),
      backgroundColor: Colors.white.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.warning_outline,
        color: ColorUtils.red.shade100,
        size: Get.height / 28,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: position,
    );
    return;
  }

  static SizedBox sizedBox([
    double heightFactor = 24,
  ]) {
    return SizedBox(
      height: Get.height / heightFactor,
    );
  }

  static softUiDivider([
    MaterialColor? color,
  ]) {
    color ??= ColorUtils.yellow;
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: color,
        gradient: LinearGradient(
          begin: const Alignment(-1.0, -4.0),
          end: const Alignment(1.0, 4.0),
          colors: [
            color,
            color.shade300,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.shade700.withOpacity(0.7),
            offset: const Offset(3.0, 3.0),
            blurRadius: 12.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: color.withOpacity(0.2),
            offset: const Offset(-5.0, -5.0),
            blurRadius: 12.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  static Widget blurWidget({
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: child,
      ),
    );
  }
}
