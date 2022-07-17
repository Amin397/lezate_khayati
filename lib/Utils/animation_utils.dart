import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationUtils {
  static Widget loading() {
    return Lottie.asset(
      'assets/animations/loading.json',
    );
  }
}
