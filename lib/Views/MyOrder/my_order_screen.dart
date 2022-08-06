import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/MyOrder/my_order_controller.dart';
import '../../Plugins/neu/src/widget/container.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import 'Widget/build_my_order_item_widget.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({Key? key}) : super(key: key);

  final MyOrderController controller = Get.put(MyOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      backgroundColor: Colors.grey[200],
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            _buildSearchBox(),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Obx(
                  () => (controller.isLoaded.isTrue)
                      ? _buildOrderList()
                      : _buildShimmer(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          depth: -3,
          lightSource: LightSource.topLeft,
          color: Colors.grey[100],
        ),
        margin: paddingAll10,
        child: Container(
          width: Get.width,
          height: Get.height * .05,
          padding: paddingAll4,
          child: TextField(
            onChanged: (s) {
              controller.search(text: s);
            },
            controller: controller.searchTextController,
            textAlign: TextAlign.start,
            maxLines: 1,
            cursorColor: Colors.black,
            style: TextStyle(
              color: ColorUtils.textColor,
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: 'جستجو',
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
              border: InputBorder.none,
            ),
            textAlignVertical: TextAlignVertical.bottom,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        'سفارش های من',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'myOrder',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/myOrder.png',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: paddingSymmetricH24,
        child: Divider(),
      ),
      itemCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _BuildShimmerItem(),
    );
  }

  Widget _BuildShimmerItem() {
    return Container(
      height: Get.height * .1,
      width: Get.width,
      margin: paddingAll8,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.2),
        highlightColor: Colors.white24,
        child: Container(
          width: Get.width,
          // margin: paddingAll10,
          height: Get.height * .25,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: radiusAll12,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.orderList
            .where((element) => element.visible.isTrue)
            .toList()
            .length,
        itemBuilder: (BuildContext context, int index) =>
            BuildMyOrderItemWidget(
          order: controller.orderList
              .where((element) => element.visible.isTrue)
              .toList()[index],
          index: index,
          controller: controller,
        ),
      ),
    );
  }
}
