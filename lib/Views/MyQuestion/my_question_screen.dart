import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/MyQuestion/my_question_controller.dart';

class MyQuestionScreen extends StatelessWidget {
  MyQuestionScreen({Key? key}) : super(key: key);

  final MyQuestionController controller = Get.put(MyQuestionController());

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
        'پرسش های من',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'myQuestion',
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image(
                image: AssetImage(
                  'assets/img/myQuestion.png',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
