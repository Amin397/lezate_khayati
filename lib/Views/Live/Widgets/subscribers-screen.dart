import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lezate_khayati/Utils/Consts.dart';

class SubscribersScreen extends StatelessWidget {
  SubscribersScreen(
      {Key? key, required this.subscripers, required this.callback})
      : super(key: key);
  Map<String, dynamic> subscripers = {};
  Callback callback;

  @override
  Widget build(BuildContext context) {
  //   print('subscripers\n\n\n\n\n');
  //   print(subscripers.length);
    return Container(
      height: Get.height,
      width: Get.width,
      padding: paddingAll10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
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
            child: ListView.builder(
              itemCount:
                  subscripers.entries.map((e) => e.value).toList().length,
              itemBuilder: (_, index) {
                var item = subscripers.entries.map((e) => e.value).toList();
                return Container(
                  height: 50,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          item[index]['img'] ?? 'img',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Text(item[index]['name'] ?? 'name'),
                      Spacer(),
                      const Icon(Icons.file_upload_outlined),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
