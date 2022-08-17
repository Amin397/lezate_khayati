import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/SingleBook/single_book_controller.dart';
import '../../Utils/Consts.dart';
import '../../Utils/view_utils.dart';

class SingleBookScreen extends StatelessWidget {
  SingleBookScreen({Key? key}) : super(key: key);

  final SingleBookController controller = Get.put(SingleBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.name,
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.grey[200],
        child: Column(
          children: [
            _buildImage(),
            Obx(
              () => (controller.isLoaded.isTrue)
                  ? Expanded(
                      child: SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            _buildDescription(),
                            _buildRateAndView(),
                            _buildDownloadButton()
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: _buildShimmer(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateAndView() {
    return Container(
      height: Get.height * .06,
      width: Get.width,
      padding: paddingAll12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRateBar(
            rate: controller.model.reviewsrating!,
          ),
          _buildView(
            view: controller.model.reviews!,
          ),
        ],
      ),
    );
  }

  Widget _buildRateBar({required int rate}) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.star,
              color: (rate >= 1) ? Colors.yellow.shade800 : Colors.grey,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 2) ? Colors.yellow.shade800 : Colors.grey,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 3) ? Colors.yellow.shade800 : Colors.grey,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 4) ? Colors.yellow.shade800 : Colors.grey,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 5) ? Colors.yellow.shade800 : Colors.grey,
              size: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView({required int view}) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 20.0,
              color: Colors.grey,
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              view.toString(),
              style: TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: Get.width,
      height: Get.height * .08,
      margin: paddingAll16,
      child: Align(
        alignment: Alignment.topRight,
        child: AutoSizeText(
          // controller.model.description!,
          parse(parse(controller.model.description!).body!.text).documentElement!.text,
          maxFontSize: 16.0,
          minFontSize: 10.0,
          maxLines: 5,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: Get.width,
      height: Get.height * .35,
      margin: paddingAll16,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
        boxShadow: ViewUtils.neoShadow(),
        color: Colors.white,
      ),
      child: Hero(
        tag: 'book-${controller.index}',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              controller.image,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.2),
          highlightColor: Colors.white24,
          child: Container(
            width: Get.width,
            margin: paddingAll10,
            height: Get.height * .15,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: radiusAll12,
            ),
          ),
        ),
        // SizedBox(
        //   height: Get.height * .03,
        // ),
        SizedBox(
          height: Get.height * .15,
          width: Get.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .17,
          width: Get.width,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(.2),
                  highlightColor: Colors.white24,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    margin: paddingAll10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: radiusAll12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: (controller.isDownloadStart.isTrue)
              ? _buildCancel()
              : InkWell(
                  onTap: () {
                    controller.downloadFile(
                      fileUrl: controller.model.link,
                      filename: controller.model.name,
                    );
                  },
                  child: Container(
                    height: Get.height * .05,
                    width: Get.width,
                    margin: paddingAll12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: radiusAll10,
                      boxShadow: ViewUtils.neoShadow(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                        ),
                        SizedBox(
                          width: Get.width * .05,
                        ),
                        AutoSizeText(
                          'بارگیری فایل',
                          maxFontSize: 20.0,
                          minFontSize: 12.0,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCancel() {
    return Container(
      height: Get.height * .05,
      width: Get.width,
      margin: paddingAll12,
      child: Row(
        children: [
          Obx(
            () => Container(
              width: Get.width * .1,
              height: double.maxFinite,
              child: Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.green.shade700,
                      value: controller.progress.value,
                    ),
                  ),
                  Center(
                    child: AutoSizeText(
                      (controller.progress * 100).toInt().toString() + '%',
                      maxFontSize: 14.0,
                      maxLines: 1,
                      minFontSize: 10.0,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: Get.width * .05,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (controller.isDownloadCompleted.isTrue) {
                  controller.openFile();
                } else {
                  controller.cancelRequest();
                }
              },
              child: AnimatedContainer(
                duration: Duration(
                  milliseconds: 300,
                ),
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: (controller.isDownloadCompleted.isTrue)
                      ? Colors.blue.shade700
                      : Colors.red,
                  borderRadius: radiusAll8,
                ),
                child: (controller.isDownloadCompleted.isTrue)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          Text(
                            'باز کردن فایل',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: AutoSizeText(
                          'انصراف',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
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
