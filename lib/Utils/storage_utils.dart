import 'package:get_storage/get_storage.dart';

class StorageUtils {

  static final box = GetStorage();


  static Future<void> saveUser(String mobile) async {

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

  static Future<String> getToken() async {
    final box = GetStorage();
    return box
        .read(
          'token',
        )
        .toString()
        .trim();
  }

  static Future<void> saveToken(String data) async {
    print("Token Is Being Saved: $data");
    final box = GetStorage();
    await box.write('token', data);
  }

  static Future<void> clearToken() async {
    await box.remove('token');
  }

  static logout() async {
    final box = GetStorage();
    await box.remove('token');
  }
}
