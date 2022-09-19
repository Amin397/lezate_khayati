import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/MyFavorite/my_favorite_controller.dart';
import 'package:lezate_khayati/Models/MyFavorite/favorite_post_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildPostsFavoriteWidget extends StatelessWidget {
  const BuildPostsFavoriteWidget({Key? key, required this.controller})
      : super(key: key);

  final MyFavoriteController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: GetBuilder(
        init: controller,
        id: 'favePost',
        builder: (ctx) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: ((Get.width / 2) / (Get.height * .15) / 2),
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) => _buildItem(
            index: index,
            item: controller.favoritePostList
                .where((element) => element.visible.isTrue)
                .toList()[index],
          ),
          // itemCount: controller.showMoreItem!.length,
          itemCount: controller.favoritePostList
              .where((element) => element.visible.isTrue)
              .length,
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required FavoritePostModel item,
  }) {
    return InkWell(
      onTap: () {
        controller.goToSingleArticle(
          index: index,
          article: item,
        );
      },
      child: Container(
        margin: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: ViewUtils.neoShadow(),
          borderRadius: radiusAll8,
        ),
        child: Stack(
          children: [
            _buildImage(
              index: index,
              img: item.post!.first.img,
            ),
            _buildShadow(),
            _buildName(
              name: item.post!.first.name,
            ),
            _buildViewPart(
              productView: item.post!.first.reviewsRating.toString(),
            ),
          ],
        ),
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

  Widget _buildImage({required int index, String? img}) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Hero(
        tag: 'article-$index',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              img!,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
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

  Widget _buildName({String? name}) {
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
                  name!,
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
