import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../Controllers/Main/main_controller.dart';

class BuildHomeBottomNavigationWidget extends StatelessWidget {
  const BuildHomeBottomNavigationWidget({Key? key, required this.controller})
      : super(key: key);

  final MainController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SalomonBottomBar(
        currentIndex: controller.currentIndex.value,
        onTap: (i) {
          controller.changePage(i);
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.teal,
            ),
            title: Text("پروفایل"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: Icon(
              Icons.music_note,
              color: Colors.yellow.shade800,
            ),
            title: Text("موزیک"),
            selectedColor: Colors.yellow.shade800,
          ),
          SalomonBottomBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.purple,
            ),
            title: Text("خانه"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.pink,
            ),
            title: Text("چت"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.red,
            ),
            title: Text("آموزش ها"),
            selectedColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
