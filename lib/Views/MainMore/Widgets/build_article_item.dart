import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Training/Books/articles_model.dart';

import '../../../Controllers/MainMore/main_more_controller.dart';
import '../../../Models/Home/home_articles_model.dart';
import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildArticleItem extends StatelessWidget {
  const BuildArticleItem({
    Key? key,
    required this.controller,
    required this.index,
    required this.article,
  }) : super(key: key);

  final MainMoreController controller;
  final HomeArticlesModel article;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: Stack(
        children: [
          _buildImage(),
          _buildShadow(),
          _buildName(),
          _buildViewPart(
            productView: article.views!,
          ),
        ],
      ),
    );
  }

  Widget _buildViewPart({required String productView}) {
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

  Widget _buildImage() {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            article.img!,
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

  Widget _buildName() {
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
                  article.name!,
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
