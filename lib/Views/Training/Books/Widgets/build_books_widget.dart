import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Training/Books/books_and_articles_controller.dart';
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

class BuildBooksWidget extends StatelessWidget {
  const BuildBooksWidget({Key? key, required this.controller})
      : super(key: key);

  final BooksAndArticlesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Obx(
        () => (controller.bookLoaded.isTrue)
            ? (controller.booksList.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          ((Get.width / 2) / (Get.height * .16) / 2),
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => _buildBooksItem(
                      book: controller.booksList[index],
                    ),
                    itemCount: controller.booksList.length,
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

  Widget _buildBooksItem({required BooksModel book}) {
    return Container(
      margin: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: Stack(
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
          _buildName(
            book: book,
          ),
          _buildRateAndView(
            book: book,
          ),
          Center(
            child: IconButton(
              icon: Icon(
                Icons.download,
                size: 40.0,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget _buildName({
    required BooksModel book,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: Get.width,
        height: Get.height * .06,
        child: Center(
          child: AutoSizeText(
            book.name!,
            maxLines: 2,
            textDirection: TextDirection.rtl,
            maxFontSize: 20.0,
            minFontSize: 10.0,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRateAndView({required BooksModel book}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Get.height * .06,
        width: Get.width,
        padding: paddingAll6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRateBar(
              rate: book.reviewsrating!,
            ),
            _buildView(
              view: book.reviews!,
            ),
          ],
        ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.star,
              color: (rate >= 1)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 2)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 3)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 4)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: (rate >= 5)
                  ? Colors.yellow.shade800
                  : Colors.white.withOpacity(.3),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 15.0,
              color: Colors.white60,
            ),
            Text(
              view.toString(),
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
}
