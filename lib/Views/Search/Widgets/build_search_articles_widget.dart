import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Search/search_controller.dart';
import 'package:lezate_khayati/Models/Search/search_article_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildSearchArticlesWidget extends StatelessWidget {
  const BuildSearchArticlesWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: GetBuilder(
        init: controller,
        id: 'showSearch',
        builder: (ctx) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: ((Get.width / 2) / (Get.height * .16) / 2),
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) => _buildArticleItem(
            article: controller.articlesList[index],
            index: index,
          ),
          itemCount: controller.articlesList.length,
        ),
      ),
    );
  }

  Widget _buildArticleItem(
      {required SearchArticleModel article, required int index}) {
    return Container(
      margin: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: Stack(
        children: [
          _buildImage(
            image: article.img!,
          ),
          _buildShadow(),
          _buildName(
            name: article.name!,
          ),
          _buildViewPart(
            productView: article.views!,
          ),
        ],
      ),
    );
  }

  Widget _buildViewPart({
    required String productView,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Get.height * .04,
        width: Get.width,
        padding: paddingAll6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildView(
              view: productView,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView({required String view}) {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 15.0,
              color: Colors.white60,
            ),
            Text(
              view,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage({required String image}) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            image,
          ),
          placeholder: AssetImage(
            'assets/img/placeHolder.jpg',
          ),
        ),
      ),
    );
  }

  Widget _buildShadow() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: radiusAll10,
        color: Colors.black38,
      ),
    );
  }

  Widget _buildName({required String name}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: Get.width,
          height: Get.height * .05,
          padding: paddingAll4,
          child: Center(
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.topCenter,
                child: AutoSizeText(
                  name,
                  maxFontSize: 18.0,
                  minFontSize: 12.0,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
