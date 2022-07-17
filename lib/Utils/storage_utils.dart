import 'package:get_storage/get_storage.dart';

class StorageUtils {
  static Future<void> saveUser(String mobile) async {
    final box = GetStorage();
    await box.write(
      'mobile',
      mobile,
    );
  }

  static Future<String?> getMobile() async {
    final box = GetStorage();
    return box.read(
      'mobile',
    );
  }
}
