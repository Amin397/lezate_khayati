import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../Controllers/Main/main_controller.dart';
import '../Chat/chat_screen.dart';
import '../Home/home_screen.dart';
import '../Music/music_screen.dart';
import '../Profile/profile_screen.dart';
import '../Training/training_screen.dart';
import 'Widgets/build_home_bottom_navigation_widget.dart';

class MainScreen extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: BuildHomeBottomNavigationWidget(controller:controller,),
        body:  PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MusicScreen(),
            ChatScreen(),
            HomeScreen(),
            TrainingScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
