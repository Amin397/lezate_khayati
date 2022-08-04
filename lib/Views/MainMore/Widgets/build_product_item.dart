import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/products_model.dart';

import '../../../Controllers/MainMore/main_more_controller.dart';
import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';

class BuildProductItem extends StatelessWidget {
  const BuildProductItem({
    Key? key,
    required this.controller,
    required this.index,
    required this.productItem,
  }) : super(key: key);

  final MainMoreController controller;
  final ProductsModel productItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.goToSingleProduct(
          index: index,
          product: productItem,
        );
      },
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        margin: paddingAll12,
        decoration: BoxDecoration(
          borderRadius: radiusAll10,
          boxShadow: ViewUtils.neoShadow(),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildImage(),
            _buildShadow(),
            _buildViewPart(
              productView: productItem.views!,
            ),
            _buildName(),
            _buildPrice()
          ],
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Positioned(
      bottom: Get.height * .04,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: paddingAll8,
          width: Get.width * .44,
          height: Get.height * .05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'قیمت :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      ViewUtils.moneyFormat(
                            double.parse(
                              productItem.price!,
                            ),
                          ) +
                          '  تومان',
                      maxLines: 1,
                      maxFontSize: 18.0,
                      minFontSize: 12.0,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: Get.width,
        height: Get.height * .06,
        child: Center(
          child: AutoSizeText(
            productItem.name!,
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
      child: Hero(
        tag: 'products-$index',
        child: ClipRRect(
          borderRadius: radiusAll10,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              productItem.img!,
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
}
