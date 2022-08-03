import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Controllers/Home/home_controller.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

class BuildShowListWidget extends StatelessWidget {
  const BuildShowListWidget({
    Key? key,
    required this.controller,
    required this.title,
    required this.id,
    required this.list,
  }) : super(key: key);

  final HomeController controller;
  final String title;
  final int id;
  final List list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * .17,
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: Get.height * .04,
            padding: paddingSymmetricH12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  title,
                  maxLines: 1,
                  maxFontSize: 18.0,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.showMore(
                      id: id,
                      title: title,
                    );
                  },
                  child: Text(
                    'بیشتر',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) => _buildItem(
                  item: list[index],
                  index: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required item,
    required int index,
  }) {
    return Container(
      width: Get.width * .2,
      height: Get.width * .2,
      margin: paddingAll12,
      decoration: BoxDecoration(
        boxShadow: ViewUtils.neoShadow(),
        borderRadius: radiusAll8,
      ),
      child: ClipRRect(
        borderRadius: radiusAll12,
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
    );
  }
}
