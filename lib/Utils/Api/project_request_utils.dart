import 'dart:convert';

import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/WebControllers.dart';
import 'package:lezate_khayati/Utils/Api/WebMethods.dart';
import 'package:lezate_khayati/Utils/storage_utils.dart';

class RequestsUtil extends GetConnect {
  static RequestsUtil instance = RequestsUtil();

  static String token = 'test';

  static String baseRequestUrl = 'https://beeswash.com/admin';

  String _makePath(WebControllers webController, String webMethod) {
    String controller = webController.toString().split('.').last;
    controller = controller.capitalizeFirst!;
    return "${RequestsUtil.baseRequestUrl}/$controller/API/${'_${webMethod.toString()}'}?token=${RequestsUtil.token}";
  }

  Future<ApiResult> makeRequest({
    required WebControllers webController,
    required String webMethod,
    Map body = const {},
  }) async {
    String url = _makePath(webController, webMethod);
    print("Request url: $url\nRequest body: ${jsonEncode(body)}\n");
    Response response = await post(
      url,
      body,
      headers: {
        'token': RequestsUtil.token,
      },
    );
    print(response.body);
    ApiResult apiResult = ApiResult();
    if (response.statusCode == 200) {
      try {
        Map data = jsonDecode(response.body);
        apiResult.isDone = data['isDone'] == true;
        apiResult.requestedMethod = data['requestedMethod'].toString();
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        apiResult.requestedMethod = webMethod.toString().split('.').last;
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = false;
    }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "requestedMethod: ${apiResult.requestedMethod}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }

  Future<ApiResult> userInfo(
    String mobile,
  ) async {
    return makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.userInfo,
      body: {
        'mobile': mobile,
      },
    );
  }

  Future<ApiResult> register({
    required String mobile,
    required String code,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.register,
      body: {
        'mobile': mobile,
        'code': code,
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> forgotPassword(String mobile) async {
    return await makeRequest(
      body: {
        'mobile': mobile,
      },
      webMethod: WebMethods.forgotPassword,
      webController: WebControllers.users,
    );
  }

  Future<ApiResult> forgotPasswordConfirm(String mobile, String code) async {
    return await makeRequest(
      body: {
        'mobile': mobile,
        'code': code,
      },
      webMethod: WebMethods.forgotPasswordConfirm,
      webController: WebControllers.users,
    );
  }

  Future<ApiResult> login({
    required String mobile,
    required String password,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.login,
      body: {
        'mobile': mobile,
        'code': password,
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> startLoginRegister({required String mobile}) async {
    return await makeRequest(
      body: {
        'mobile': mobile,
      },
      webMethod: WebMethods.startLoginRegister,
      webController: WebControllers.users,
    );
  }

  Future<ApiResult> getServices() async {
    return await makeRequest(
      webMethod: WebMethods.list,
      webController: WebControllers.services,
    );
  }

  Future<ApiResult> getSizes() async {
    return await makeRequest(
      webMethod: WebMethods.list,
      webController: WebControllers.sizes,
    );
  }

  Future<ApiResult> singleService(int serviceId) async {
    return await makeRequest(
      body: {
        'serviceId': serviceId.toString(),
      },
      webMethod: WebMethods.single,
      webController: WebControllers.services,
    );
  }

  Future<ApiResult> completeRegister({
    required String name,
    required String lastName,
    required String code,
    required String mobile,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.completeRegister,
      body: {
        "name": name,
        "lastName": lastName,
        "mobile": mobile,
        "code": code,
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> addressList() async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.addressList,
      body: {
        "mobile": await StorageUtils.getMobile(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> submitAddress({
    required double latitude,
    required double longitude,
    required String title,
    required String plaque,
    required String address,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.submitAddress,
      body: {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "title": title.toString(),
        "plaque": plaque.toString(),
        "address": address.toString(),
        'mobile': await StorageUtils.getMobile(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> deleteAddress({required String id}) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.deleteAddress,
      body: {
        "id": id,
        'mobile': await StorageUtils.getMobile(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> orders() async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.orders,
      body: {
        'mobile': await StorageUtils.getMobile(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> submitOrder({
    required List<int> services,
    required int addressId,
    required int sizeId,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.submitOrder,
      body: {
        "addressId": addressId.toString(),
        "sizeId": sizeId.toString(),
        "services": jsonEncode(services),
        'mobile': await StorageUtils.getMobile(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> editAddress({
    required String title,
    required String plaque,
    required String address,
    required int addressId,
  }) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.editAddress,
      body: {
        "title": title.toString(),
        "plaque": plaque.toString(),
        "address": address.toString(),
        'mobile': await StorageUtils.getMobile(),
        'addressId': addressId.toString(),
      },
    ).timeout(const Duration(seconds: 50));
  }

  Future<ApiResult> appVersion(String version) async {
    return await makeRequest(
      webController: WebControllers.users,
      webMethod: WebMethods.appVersion,
      body: {
        'version': version.toString(),
      },
    ).timeout(const Duration(seconds: 50));
  }
}

class ApiResult {
  late bool isDone;
  String? requestedMethod;
  dynamic data;

  ApiResult({
    this.isDone = false,
    this.requestedMethod,
    this.data,
  });
}
