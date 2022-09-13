import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Models/Live/comment_model.dart';
import 'package:lottie/lottie.dart';

import '../../../Globals/Globals.dart';
import '../../../Models/user_model.dart';
import '../../../Utils/Api/project_request_utils.dart';
import '../../../Utils/Consts.dart';
import '../../../Utils/color_utils.dart';

class CommentPart extends StatefulWidget {
  const CommentPart({
    Key? key,
    required this.liveId
  }) : super(key: key);


  final String liveId;

  @override
  State<CommentPart> createState() => _CommentPartState();
}

class _CommentPartState extends State<CommentPart> with TickerProviderStateMixin{


  final ScrollController scrollController = ScrollController();
  final List<CommentModel> commentsList = [];
  TextEditingController messageController = TextEditingController();

  late final AnimationController animationController;



  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('*****************************');
      if (message.data['title'] == 'کنفرانس') {
        getUsers();
      } else if (message.data['title'] == 'comment') {
        setState(() {
          commentsList
              .add(CommentModel.fromJson(jsonDecode(message.data['message'])));
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 30,
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.easeInOut,
          );
        });
      }
    });


  }

  getUsers() async {
    ApiResult result = await RequestsUtil.instance.getLiveJoinedUser(
      liveId: widget.liveId.toString(),
    );
    if (result.isDone) {
      // for (var o in result.data) {
      //   // print(o['user']);
      //   subscribersList.add(UserModel.fromJson(o['user']));
      // }
      // setState(() {
      //   subscribers = UserModel.listFromJsonLive(result.data);
      // });
      // update(['live']);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black45,
              Colors.black38,
              Colors.black26,
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: commentsList.length,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCommentItem(comment: commentsList[index]);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            // Container(
            //   padding: paddingAll8,
            //   width: MediaQuery.of(context).size.width,
            //   // height: MediaQuery.of(context).size.height * .06,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Expanded(
            //         child: AnimatedContainer(
            //           constraints: BoxConstraints(
            //             maxHeight: MediaQuery.of(context).size.height * .15,
            //           ),
            //           width: double.maxFinite,
            //           decoration: BoxDecoration(
            //             color: Colors.white.withOpacity(.5),
            //             // boxShadow: ViewUtils.shadow(
            //             //   offset: const Offset(0.0, 0.0),
            //             // ),
            //             borderRadius: radiusAll10,
            //           ),
            //           duration: const Duration(milliseconds: 270),
            //           child: TextField(
            //             onTap: () {
            //               // controller.scrollToDown();
            //             },
            //             controller: messageController,
            //             maxLines: 10,
            //             minLines: 1,
            //             style: TextStyle(
            //               color: Colors.grey.shade800,
            //             ),
            //             keyboardType: TextInputType.multiline,
            //             decoration: InputDecoration(
            //               enabledBorder: OutlineInputBorder(
            //                 borderRadius: radiusAll10,
            //                 borderSide: const BorderSide(
            //                   color: Colors.red,
            //                   width: 1.0,
            //                 ),
            //               ),
            //               focusedBorder: OutlineInputBorder(
            //                 borderRadius: radiusAll10,
            //                 borderSide: BorderSide(
            //                   color: Colors.red,
            //                   width: 1.0,
            //                 ),
            //               ),
            //               hintText: 'متن پیام',
            //               hintStyle: TextStyle(
            //                 fontSize: 12.0,
            //               ),
            //               // suffixIcon: IconButton(
            //               //   onPressed: () {
            //               //     controller.pickFile();
            //               //   },
            //               //   icon: Icon(
            //               //     Icons.attach_file,
            //               //     color: Colors.grey.shade700,
            //               //   ),
            //               // ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           if (messageController.text.isNotEmpty) {
            //             sendMessage();
            //           }
            //         },
            //         child: Lottie.asset(
            //           'assets/animations/send.json',
            //           height: MediaQuery.of(context).size.width * .15,
            //           width: MediaQuery.of(context).size.width * .15,
            //           controller: animationController,
            //           // repeat: false,
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem({required CommentModel comment}) {
    return Container(
      height: MediaQuery.of(context).size.height * .07,
      width: MediaQuery.of(context).size.width * .7,
      // margin: paddingAll6,
      margin: EdgeInsets.only(left: 0.0, bottom: 8.0, right: 4.0),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .07,
            width: MediaQuery.of(context).size.height * .07,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: paddingAll6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: (comment.user!.avatar is String)
                  ? FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  comment.user!.avatar!,
                ),
                placeholder: AssetImage(
                  'assets/img/placeHolder.jpg',
                ),
              )
                  : Center(
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              padding: paddingAll4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.6),
                borderRadius: radiusAll8,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      comment.user!.name!,
                      maxLines: 1,
                      maxFontSize: 14.0,
                      minFontSize: 10.0,
                      style: TextStyle(
                        color: ColorUtils.textColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: AutoSizeText(
                        comment.body!,
                        maxLines: 2,
                        maxFontSize: 16.0,
                        minFontSize: 10.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  void sendMessage() async {
    FocusScope.of(context).unfocus();
    String comment = messageController.text;
    messageController.clear();

    animationController
      ..duration = const Duration(milliseconds: 1800)
      ..forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      animationController.reset();
    });

    ApiResult result = await RequestsUtil.instance.sendLiveComment(
      liveId: widget.liveId.toString(),
      comment: comment,
    );

    if (result.isDone) {
      setState(() {
        commentsList.add(
          CommentModel(
            userId: Globals.userStream.user!.id.toString(),
            user: User(
              name: Globals.userStream.user!.name,
              id: Globals.userStream.user!.id,
              avatar: Globals.userStream.user!.avatar,
            ),
            body: comment,
            liveId: widget.liveId.toString(),
          ),
        );
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 30,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeInOut,
        );
      });
    }
  }


}
