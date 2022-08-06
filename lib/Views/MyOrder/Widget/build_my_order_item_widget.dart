import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/MyOrder/my_order_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

import '../../../Controllers/MyOrder/my_order_controller.dart';

class BuildMyOrderItemWidget extends StatelessWidget {
  const BuildMyOrderItemWidget({
    Key? key,
    required this.controller,
    required this.index,
    required this.order,
  }) : super(key: key);

  final MyOrderController controller;
  final MyOrderModel order;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: Get.width,
        margin: paddingAll16,
        height: (order.isCollapsed.isTrue) ? Get.height * .3 : Get.height * .13,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: ViewUtils.neoShadow(),
          borderRadius: radiusAll10,
        ),
        child: Column(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height * .13,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.collapsed(order: order);
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                    ),
                  ),
                  _buildOrderDetail(),
                  SizedBox(
                    width: Get.width * .03,
                  ),
                  _buildImage(),
                ],
              ),
            ),
            (order.isCollapsed.isTrue) ? _buildDesc() : SizedBox(),
            (order.isCollapsed.isTrue) ? _buildBuyDate() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    order.name!,
                    maxFontSize: 18.0,
                    minFontSize: 12.0,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'تومان',
                      maxLines: 1,
                      maxFontSize: 12.0,
                      minFontSize: 8.0,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    AutoSizeText(
                      ViewUtils.moneyFormat(
                        double.parse(
                          order.price!,
                        ),
                      ),
                      maxFontSize: 18.0,
                      minFontSize: 12.0,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: Get.height * .1,
      height: Get.height * .1,
      margin: paddingAll8,
      child: ClipRRect(
        borderRadius: radiusAll10,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            order.img!,
          ),
          placeholder: AssetImage(
            'assets/img/placeHolder.jpg',
          ),
        ),
      ),
    );
  }

  Widget _buildDesc() {
    return Container(
      margin: paddingAll6,
      width: Get.width,
      height: Get.height * .08,
      child: Align(
        alignment: Alignment.topRight,
        child: AutoSizeText(
          order.content!,
          maxFontSize: 16.0,
          maxLines: 2,
          minFontSize: 10.0,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBuyDate() {
    return Expanded(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          margin: paddingAll6,
          child: Row(
            children: [
              AutoSizeText(
                'خریداری شده در :',
                maxLines: 1,
                maxFontSize: 16.0,
                minFontSize: 10.0,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                width: Get.width * .05,
              ),
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      '${order.date!.first}/${order.date![1]}/${order.date!.last}',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
