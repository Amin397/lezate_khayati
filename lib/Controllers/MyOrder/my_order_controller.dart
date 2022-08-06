import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Models/MyOrder/my_order_model.dart';

class MyOrderController extends GetxController{



  TextEditingController searchTextController = TextEditingController();


  RxBool isLoaded = false.obs;

  List<MyOrderModel> orderList = [];



  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async{
    ApiResult result = await RequestsUtil.instance.getMyOrders();

    if(result.isDone){
      orderList = MyOrderModel.listFromJson(result.data['products']);
      isLoaded(true);
    }
  }

  void collapsed({required MyOrderModel order}) {
    order.isCollapsed(!order.isCollapsed.value);
  }

  void search({required String text}) {
    if (text.isEmpty) {
      orderList.forEach((element) {
        element.visible(true);
      });
    } else {
      orderList.forEach((element) {
        if (!element.name!.contains(text)) {
          element.visible(false);
        } else {
          element.visible(true);
        }
      });
    }
  }


}