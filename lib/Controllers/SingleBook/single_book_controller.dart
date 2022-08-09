import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utils/Api/project_request_utils.dart';

class SingleBookController extends GetxController {
  late final int index;
  late final int id;
  late final String image;
  late final String name;
  late final BooksModel model;

  RxBool isDownloadStart = false.obs;
  RxBool isDownloadCompleted = false.obs;
  RxBool isLoaded = false.obs;

  RxDouble progress = 0.0.obs;

  File? filePath;

  @override
  void onInit() {
    index = Get.arguments['index'];
    id = Get.arguments['id'];
    image = Get.arguments['image'];
    name = Get.arguments['name'];

    getData();
    super.onInit();
  }

  void getData() async {
    ApiResult result = await RequestsUtil.instance.singleBook(
      id: id.toString(),
    );
    if (result.isDone) {
      model = BooksModel.fromJson(result.data);
      isLoaded(true);
    }
  }

  dio.CancelToken cancelToken = dio.CancelToken();

  Future downloadFile({
    String? fileUrl,
    String? filename,
  }) async {
    print("start download");

    Directory? tempDir = await getTemporaryDirectory();
    var status = await Permission.storage.request();
    Directory? amin;
    // String? aaa;
    if (status.isGranted) {
      isDownloadStart(true);
      amin = await Directory(tempDir.path + '/' + 'books/').create();
      try {
        dio.Dio()
            .download(fileUrl!, amin.path + filename!, cancelToken: cancelToken,
                onReceiveProgress: (int receive, int total) {
          progress(receive / total);
          print(receive);
          print(total);
          update();
        }).then((value) async {
          isDownloadCompleted(true);
          print(value);
          filePath = File(
            amin!.path + filename,
          );
          print('completed');
        });
      } catch (e) {
        print(e);
        // isFileDownload = false;
        cancelRequest(
        );
      }
      update();
    }
  }

  EventSink<List<int>>? sink;

  void cancelRequest() async {
    try {
      cancelToken.cancel();
      cancelToken.whenCancel.then((value) {
        cancelToken = new dio.CancelToken();
      });
      this.sink?.close();
      isDownloadStart(false);
    } catch (e) {}
  }

  void openFile() async {
    OpenFile.open(filePath!.path);
  }
}
