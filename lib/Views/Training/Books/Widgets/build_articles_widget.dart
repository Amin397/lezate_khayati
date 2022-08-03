import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Training/Books/books_and_articles_controller.dart';
import 'package:lezate_khayati/Models/Training/Books/articles_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../../Utils/Consts.dart';
import '../../../../Utils/view_utils.dart';

class BuildArticlesWidget extends StatelessWidget {
  const BuildArticlesWidget({Key? key, required this.controller})
      : super(key: key);
  final BooksAndArticlesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Obx(
        () => (controller.articlesLoaded.isTrue)
            ? (controller.articlesList.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          ((Get.width / 2) / (Get.height * .16) / 2),
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => _buildArticlesItem(
                      book: controller.articlesList[index],
                    ),
                    itemCount: controller.articlesList.length,
                  )
                : Center(
                    child: Text(
                      'no data',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildArticlesItem({required ArticlesModel book}) {
    return Container(
      margin: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: radiusAll8,
            child: Image(
              image: AssetImage(
                'assets/img/testImage.png',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: radiusAll8,
            ),
          ),
          Positioned(
            right: -Get.width * .1,
            top: -Get.width * .05,
            child: RotationTransition(

              turns: AlwaysStoppedAnimation(40 / 360),
              child: Container(
                height: Get.width * .15,
                width: Get.width * .3,
                color: Colors.white,
              ),
            ),
          ),
          // _buildName(
          //   book: book,
          // ),
          // _buildRateAndView(
          //   book: book,
          // ),
          // Center(
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.download,
          //       size: 40.0,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}
