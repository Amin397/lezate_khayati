import 'dart:async';

import 'package:lezate_khayati/Models/user_model.dart';

import '../Plugins/get/get.dart';

class UserStream {
  // ignore: close_sinks
  final streamController = StreamController<UserModel>.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream<UserModel> get getStream => streamController.stream;

  UserModel? user;

  void changeUser(UserModel user) {
    this.user = user;
    streamController.sink.add(this.user!);
  }

  void sync() {
    streamController.sink.add(user!);
  }
}

class Globals {
  static UserStream userStream = UserStream();
  static double fontSize20 = Get.width > 400 ? 20.0 : 16.0;
  static double fontSize18 = Get.width > 400 ? 18.0 : 14.0;
  static double fontSize16 = Get.width > 400 ? 16.0 : 12.0;
  static double fontSize15 = Get.width > 400 ? 15.0 : 11.0;
  static double fontSize14 = Get.width > 400 ? 14.0 : 10.0;
  static double fontSize12 = Get.width > 400 ? 12.0 : 8.0;
  static double fontSize11 = Get.width > 400 ? 11.0 : 7.0;
  static double fontSize10 = Get.width > 400 ? 10.0 : 6.0;
}
