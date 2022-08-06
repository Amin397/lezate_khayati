import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/MyFavorite/my_favorite_controller.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({Key? key}) : super(key: key);

  final MyFavoriteController controller = Get.put(MyFavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Container(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        'لیست علاقه مندی ها',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'myFavorite',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/favorite.png',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
