import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/SingleArticle/single_article_controller.dart';
import '../../Utils/Consts.dart';
import '../../Utils/view_utils.dart';

class SingleArticleScreen extends StatelessWidget {
  SingleArticleScreen({Key? key}) : super(key: key);

  final SingleArticleController controller = Get.put(SingleArticleController());

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
                            // _buildUpdate(),
                            // if (controller.model.videos!.isNotEmpty)
                            //   _buildVideos(),
                            // if (!controller.model.isBought! && !controller.free)
                            //   _buildBuyButton()
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
        tag: 'article-${controller.index}',
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

  Widget _buildDescription() {
    return Container(
      width: Get.width,
      height: Get.height * .07,
      margin: paddingAll16,
      child: Align(
        alignment: Alignment.topRight,
        child: AutoSizeText(
          controller.model.content!,
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
}
