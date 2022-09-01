import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../../Models/user_model.dart';

class UsersOnLiveModal extends StatelessWidget {
  UsersOnLiveModal({Key? key, required this.sub}) : super(key: key);
  List<UserModel> sub;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: null);
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: Get.height * .5,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back(result: null);
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: sub.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildSubscribeUser(
                        user: sub[index],
                        index: index,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
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
              Get.back(result: user);
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
