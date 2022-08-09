import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:lezate_khayati/Globals/Globals.dart';

import '../../Plugins/get/get.dart';
import '../storage_utils.dart';
import 'WebControllers.dart';
import 'WebMethods.dart';

class RequestsUtil extends GetConnect {
  static RequestsUtil instance = RequestsUtil();

  static String token = 'test';

  static String baseRequestUrl = 'https://seeuland.com/api';

  static String _makePath({
    required WebControllers? webController,
    WebMethods? webMethod,
    String? urlParams,
  }) {
    if (webMethod == null) {
      if (urlParams is String) {
        return "${RequestsUtil.baseRequestUrl}/${webController.toString().split('.').last}/$urlParams";
      } else {
        return "${RequestsUtil.baseRequestUrl}/${webController.toString().split('.').last}";
      }
    } else {
      if (urlParams is String) {
        return "${RequestsUtil.baseRequestUrl}/${webController.toString().split('.').last}/${webMethod.toString().split('.').last}/$urlParams";
      } else {
        return "${RequestsUtil.baseRequestUrl}/${webController.toString().split('.').last}/${webMethod.toString().split('.').last}";
      }
    }
  }

  Future<ApiResult> makeRequest({
    WebControllers? webController,
    WebMethods? webMethod,
    required String type,
    String? urlParams,
    Map<String, dynamic> body = const {},
    List<File> files = const [],
    Map<String, File?> indexFiles = const {},
    Map<String, String> header = const {},
    bool bearer = false,
  }) async {
    String url = _makePath(
      webController: webController,
      webMethod: webMethod,
      urlParams: urlParams,
    );
    // Response response =
    // await post(Uri.parse(url), body: body, headers: header);
    Map<String, String> myHeaders = {};
    if (bearer) {
      myHeaders.addAll(
        {
          ...header,
          'Authorization': "Bearer ${await StorageUtils.getToken()}",
          // 'Content-Type': 'application/json',
        },
      );
      print("Headers: $myHeaders");
    } else {
      myHeaders.addAll(header);
    }
    dev.log("Request url: $url\nRequest body: ${jsonEncode(body)}\n");
    final form = FormData(body);
    files.forEach((value) {
      form.files.add(
        MapEntry(
          files.length == 1 ? 'input' : 'file[]',
          MultipartFile(
            value,
            filename: value.path.split('/').last,
          ),
        ),
      );
    });
    indexFiles.forEach((key, value) {
      if (value is File) {
        form.files.add(
          MapEntry(
            key,
            MultipartFile(
              value,
              filename: value.path.split('/').last,
            ),
          ),
        );
      }
    });
    late Response response;

    switch (type) {
      case 'get':
        {
          response = await get(
            url,
            headers: myHeaders,
          );
          break;
        }

      default:
        {
          response = await post(
            url,
            form,
            headers: myHeaders,
          );
        }
    }
    ApiResult apiResult = ApiResult(isDone: true, requestedMethod: "");
    apiResult.status = response.statusCode;

    if (response.statusCode == 200) {
      try {
        Map data = (response.body);
        apiResult.isDone = data['isDone'] == true;
        apiResult.data = data['data'];
      } catch (e) {
        apiResult.isDone = false;
        print(response.body);
        apiResult.data = response.body;
      }
    } else {
      apiResult.isDone = false;
    }
    dev.log(
        "\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "requestedMethod: ${apiResult.requestedMethod}\n"
        "data: ${apiResult.data}"
        "}");
    dev.log(jsonEncode(response.body));
    return apiResult;
  }

  Future<ApiResult> startLoginRegister({
    required String mobileNumber,
  }) async {
    return await makeRequest(
        webController: WebControllers.auth,
        webMethod: WebMethods.sendsms,
        type: 'post',
        body: {'phone': mobileNumber}
        // bearer: true,
        );
  }

  Future<ApiResult> sendCode({
    required String mobileNumber,
    required String code,
    required String name,
  }) async {
    return await makeRequest(
        webController: WebControllers.auth,
        webMethod: WebMethods.sendcode,
        type: 'post',
        body: {
          'phone': mobileNumber,
          'code': code,
          'name': name,
          'refer': 'google',
        });
  }

  Future<ApiResult> getUser() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.auth,
      webMethod: WebMethods.profile,
      bearer: true,
    );
  }

  Future<ApiResult> buyCourse({required String courseId ,}) async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.products,
      webMethod: WebMethods.buy,
      urlParams: '$courseId/${Globals.userStream.user!.id.toString()}',
      bearer: true,
    );
  }

  Future<ApiResult> getProductsData() async {
    return await makeRequest(
        type: 'get',
        webController: WebControllers.products,
        webMethod: WebMethods.archive,
        bearer: true);
  }

  Future<ApiResult> getUserClass() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.courses,
      webMethod: WebMethods.userCourses,
      urlParams: Globals.userStream.user!.id.toString(),
      bearer: true,
    );
  }

  Future<ApiResult> getMyOrders() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.courses,
      webMethod: WebMethods.userProducts,
      urlParams: Globals.userStream.user!.id.toString(),
      bearer: true,
    );
  }

  Future<ApiResult> getChatRooms() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.chats,
      bearer: true,
    );
  }

  Future<ApiResult> search({
    required String text,
  }) async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.search,
      bearer: true,
      urlParams: text,
    );
  }

  Future<ApiResult> getArticlesData() async {
    return await makeRequest(
        type: 'post', webController: WebControllers.posts, bearer: true);
  }

  Future<ApiResult> getPriceyCoursesData() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.courses,
      webMethod: WebMethods.pricy,
      bearer: true,
    );
  }

  Future<ApiResult> getFreeCoursesData() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.courses,
      webMethod: WebMethods.free,
      bearer: true,
    );
  }

  Future<ApiResult> singleBook({required String id}) async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.books,
      webMethod: WebMethods.single,
      bearer: true,
      urlParams: id,
    );
  }

  Future<ApiResult> getBooks() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.books,
      webMethod: WebMethods.archive,
    );
  }

  Future<ApiResult> singlePriceyCourse({
    required String id,
  }) async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.courses,
      webMethod: WebMethods.single,
      urlParams: id,
    );
  }

  Future<ApiResult> getHomeData() async {
    return await makeRequest(
      type: 'post',
      webController: WebControllers.theme,
      webMethod: WebMethods.TopRightSlider,
    );
  }

  Future<ApiResult> getHomeOtherData() async {
    return await makeRequest(
      type: 'get',
      webController: WebControllers.app,
      webMethod: WebMethods.home,
    );
  }

  Future<ApiResult> getArticles() async {
    return await makeRequest(
      type: 'post',
      webController: WebControllers.posts,
      // webMethod: WebMethods.archive,
    );
  }

  Future<ApiResult> completeRegister({
    required String name,
    required String refer,
  }) async {
    return await makeRequest(
        type: 'post',
        webController: WebControllers.auth,
        webMethod: WebMethods.username,
        bearer: true,
        body: {
          'name': name,
          // 'refer': refer,
        });
  }

  Future<ApiResult> getMusics() async {
    return await makeRequest(
      type: 'post',
      webController: WebControllers.musics,
      webMethod: WebMethods.archive,
    );
  }
}

class ApiResult {
  bool isDone;
  String requestedMethod;
  dynamic data;
  dynamic status;

  ApiResult({
    required this.isDone,
    required this.requestedMethod,
    this.data,
    this.status,
  });
}
