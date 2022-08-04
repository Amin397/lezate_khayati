import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Training/Books/books_model.dart';

import '../../../Controllers/MainMore/main_more_controller.dart';
import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildMainBookItem extends StatelessWidget {
  const BuildMainBookItem({
    Key? key,
    required this.controller,
    required this.book,
    required this.index,
  }) : super(key: key);

  final MainMoreController controller;
  final BooksModel book;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        controller.goToSingleBook(book:book,index:index,);
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
            _buildImage(),
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
          ],
        ),
      ),
    );
  }


  Widget _buildImage() {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Hero(
        tag: 'book-$index',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              book.img!,
            ),
            placeholder: AssetImage(
              'assets/img/placeHolder.jpg',
            ),
          ),
        ),
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
              rate: book.reviewsRating!,
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
