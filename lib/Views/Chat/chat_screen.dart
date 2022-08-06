import 'package:flutter/material.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controllers/Chat/chat_controller.dart';
import '../../Plugins/neu/flutter_neumorphic.dart';
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import 'Widget/build_chat_item_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.grey[200],
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              height: Get.height * .04,
            ),
            _buildSearchBox(),
            SizedBox(
              height: Get.height * .04,
            ),
            (controller.isLoaded.isTrue) ? _buildChatList() : _buildShimmer(),
            SizedBox(
              height: Get.height * .01,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        depth: -3,
        lightSource: LightSource.topLeft,
        color: Colors.grey[100],
      ),
      margin: paddingSymmetricH8,
      child: Container(
        width: Get.width,
        height: Get.height * .05,
        padding: paddingAll4,
        child: TextField(
          onChanged: (s) {
            controller.search(text: s);
          },
          controller: controller.searchTextController,
          textAlign: TextAlign.start,
          maxLines: 1,
          cursorColor: Colors.black,
          style: TextStyle(
            color: ColorUtils.textColor,
            fontSize: 15.0,
          ),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'جستجو',
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
          ),
          textAlignVertical: TextAlignVertical.bottom,
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Obx(
          () => ListView.separated(
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: controller.chatList
                .where((element) => element.visible.isTrue)
                .toList()
                .length,
            itemBuilder: (BuildContext context, int index) =>
                BuildChatItemWidget(
              item: controller.chatList
                  .where((element) => element.visible.isTrue)
                  .toList()[index],
              index: index,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Expanded(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context , int index)=>_buildShimmerItem(),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      height: Get.height * .1,
      width: Get.width,
      margin: paddingAll8,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.2),
        highlightColor: Colors.white24,
        child: Container(
          width: Get.width,
          // margin: paddingAll10,
          height: Get.height * .25,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: radiusAll12,
          ),
        ),
      ),
    );
  }
}
