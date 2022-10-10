import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Home/product_category_model.dart';

import '../../../Controllers/ProductCategory/product_category_controller.dart';
import '../../../Plugins/get/get.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/view_utils.dart';


class BuildProductCategoryItem extends StatelessWidget {
  const BuildProductCategoryItem({Key? key , required this.controller, required this.item, required this.index}) : super(key: key);


  final ProductCategoryController controller;
  final ProductCategoryModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.goToProduct(
          index: index,
          product: item,
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
            _buildName(),
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
              item.img!,
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



  Widget _buildName() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: Get.width,
        height: Get.height * .06,
        child: Center(
          child: AutoSizeText(
            item.name!,
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





}
