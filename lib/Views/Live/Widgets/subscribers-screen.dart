import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lezate_khayati/Controllers/Live/live_controller.dart';
import 'package:lezate_khayati/Models/user_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class SubscribersScreen extends StatelessWidget {
  SubscribersScreen(
      {Key? key,
      required this.subscripers,
      required this.callback,
      required this.controller})
      : super(key: key);
  Map<String, dynamic> subscripers = {};
  final LiveController controller;
  Callback callback;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: Get.height,
        width: Get.width,
        padding: paddingAll10,
        decoration: BoxDecoration(
          color: Colors.white,

          // borderRadius: BorderRadius.vertical(
          //   top: Radius.circular(12.0),
          // ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  // Get.back();
                  callback();
                },
                icon: Icon(Icons.clear),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: GetBuilder(
                  init: controller,
                  id: 'live',
                  builder: (ctx) => ListView.builder(
                    itemCount:
                        // subscripers.entries.map((e) => e.value).toList().length,
                        controller.subscribersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      // var item = subscripers.entries.map((e) => e.value).toList();
                      return _buildSubscribeUser(
                        user: controller.subscribersList[index],
                        index: index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeUser({
    required UserModel user,
    required int index,
  }) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              controller.addToLive(
                user: user,
              );
            },
            child: Text(
              'افزودن به Live',
            ),
          ),
          Spacer(),
          Text(
            user.name!,
          ),
          (user.avatar is String)
              ? ClipRRect(
                  child: Image.network(
                    user.avatar!,
                    width: 40,
                    height: 40,
                  ),
                )
              : Icon(
                  Icons.person,
                ),
        ],
      ),
    );
  }
}
