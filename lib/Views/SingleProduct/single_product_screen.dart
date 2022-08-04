import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/SingleProduct/single_product_controller.dart';


class SingleProductScreen extends StatelessWidget {
  SingleProductScreen({Key? key}) : super(key: key);


  final SingleProductController controller = Get.put(SingleProductController());

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
