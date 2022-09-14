// import 'dart:io';
//
// import 'package:agora_rtc_engine/rtc_channel.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:lezate_khayati/Globals/Globals.dart';
// import 'package:lezate_khayati/Plugins/get/get.dart';
//
// import '../../Models/user_model.dart';
// import '../../Utils/Api/project_request_utils.dart';
// import '../../Utils/Consts.dart';
// import '../JoinLive/Widgets/build_invite_alert.dart';
// import 'Widgets/users_on_live_modal.dart';
//
// class LobbyPage extends StatefulWidget {
//   LobbyPage({Key? key, this.broadCast, this.liveId}) : super(key: key);
//
//   bool? broadCast;
//   final String? liveId;
//
//   @override
//   _LobbyPageState createState() => _LobbyPageState();
// }
//
// class _LobbyPageState extends State<LobbyPage> {
//   static final _users = <int>[];
//   static final _users2 = <int>[];
//
//   final _infoStrings = <String>[];
//   List<UserModel> subscribersList = [];
//
//   bool muted = false;
//   bool camera = false;
//   bool switched = false;
//
//   RtcEngine? _engine;
//   RtcChannel? _channel;
//
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     _users2.clear();
//     // destroy sdk
//     _engine!.leaveChannel();
//     _engine!.destroy();
//     _channel!.leaveChannel();
//     _channel!.destroy();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('*****************************');
//       if (message.data['title'] == 'کنفرانس') {
//         if (Globals.userStream.user!.role == 'admin') {
//           getUsers();
//         } else if (message.data['body'] == 'شما به لایو دعوت شده اید') {
//           // _users.clear();
//           // _users2.clear();
//           // // destroy sdk
//           // _engine!.leaveChannel();
//           // _engine!.destroy();
//           // _channel!.leaveChannel();
//           // _channel!.destroy();
//           //
//           //
//           // widget.broadCast = true;
//           // initialize();
//
//           setPublisher();
//         }
//       }
//     });
//
//     initialize();
//   }
//
//   setPublisher() async {
//     print('-------------------------- show dialog -------------------');
//     bool accept = await showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (BuildContext context) => AlertDialog(
//         backgroundColor: Colors.transparent,
//         contentPadding: EdgeInsets.zero,
//         content: BuildInviteAlert(),
//       ),
//     );
//     //
//     if (accept) {
//       Get.back();
//       Future.delayed(Duration(milliseconds: 500), () {
//         Get.to(() => LobbyPage(broadCast: true, liveId: widget.liveId));
//       });
//       //  callEnd();
//       // LiveController liveController = Get.put(LiveController());
//       //  joinToChat();
//     }
//   }
//
//   getUsers() async {
//     subscribersList.clear();
//     ApiResult result = await RequestsUtil.instance.getLiveJoinedUser(
//       liveId: widget.liveId.toString(),
//     );
//     if (result.isDone) {
//       for (var o in result.data) {
//         // print(o['user']);
//         subscribersList.add(UserModel.fromJson(o['user']));
//       }
//       // subscribersList = UserModel.listFromJsonLive(result.data);
//       setState(() {});
//     }
//   }
//
//   Future<void> initialize() async {
//     _engine = await RtcEngine.create(appId);
//     await _engine!.enableVideo();
//     await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     _addAgoraEventHandlers();
//     await _engine!.joinChannel(token, 'aminroom400', null, 0);
//
//     _channel = await RtcChannel.create('aminroom400');
//     _addRtcChannelEventHandlers();
//     if (widget.broadCast!) {
//       await _engine!.setClientRole(ClientRole.Broadcaster);
//     } else {
//       await _engine!.setClientRole(ClientRole.Audience);
//     }
//     await _channel!.joinChannel(
//       token,
//       null,
//       0,
//       ChannelMediaOptions(
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: true,
//       ),
//     );
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine!.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         setState(() {
//           final info = 'onError: $code';
//           _infoStrings.add(info);
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           final info = 'onJoinChannel: $channel, uid: $uid';
//           _infoStrings.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           _infoStrings.add('onLeaveChannel');
//           _users.clear();
//           if (Globals.userStream.user!.role == 'admin') {
//             getUsers();
//           }
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           final info = 'userJoined: $uid';
//           _infoStrings.add(info);
//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         setState(() {
//           final info = 'userOffline: $uid , reason: $reason';
//           _infoStrings.add(info);
//           _users.remove(uid);
//         });
//       },
//     ));
//   }
//
//   void _addRtcChannelEventHandlers() {
//     _channel!.setEventHandler(RtcChannelEventHandler(
//       error: (code) {
//         setState(() {
//           _infoStrings.add('Rtc Channel onError: $code');
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           final info = 'Rtc Channel onJoinChannel: $channel, uid: $uid';
//           _infoStrings.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           _infoStrings.add('Rtc Channel onLeaveChannel');
//           _users2.clear();
//           if (Globals.userStream.user!.role == 'admin') {
//             getUsers();
//           }
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           final info = 'Rtc Channel userJoined: $uid';
//           _infoStrings.add(info);
//           _users2.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         setState(() {
//           final info = 'Rtc Channel userOffline: $uid , reason: $reason';
//           _infoStrings.add(info);
//           _users2.remove(uid);
//         });
//       },
//     ));
//   }
//
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.topLeft,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return const SizedBox();
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: const TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text('ویدئو کنفرانس'),
//         actions: [
//           (Globals.userStream.user!.role == 'admin')
//               ? GestureDetector(
//                   onTap: () {
//                     showUsers();
//                   },
//                   child: Container(
//                     padding: paddingAll8,
//                     child: Row(
//                       children: [
//                         Text(
//                           subscribersList.length.toString(),
//                         ),
//                         SizedBox(
//                           width: 3.0,
//                         ),
//                         Icon(
//                           Icons.visibility_outlined,
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               : SizedBox(),
//           if (Globals.userStream.user!.role == 'admin')
//             IconButton(
//               onPressed: () {
//                 pickFile();
//               },
//               icon: Icon(Icons.upload_file),
//             ),
//         ],
//       ),
//       // backgroundColor: Colors.black,
//       body: Stack(
//         children: <Widget>[
//           _viewRows(),
//           _viewRtcRows(),
//           _tools(),
//           _panel(),
//         ],
//       ),
//     );
//   }
//
//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.media,
//     );
//     if (result != null) {
//       File file = File(result.files.single.path!);
//
//       switch (file.path.split('.').last) {
//         case 'png':
//           {
//             print('png');
//             break;
//           }
//         case 'jpeg':
//           {
//             print('jpeg');
//             break;
//           }
//         // case 'mp4':
//         //   {
//         //     file = await getThumb(filePath: file.path);
//         //     isVideo = true;
//         //     print('mp4');
//         //     break;
//         //   }
//         default:
//           {
//             print(file.path.split('.').last.toString());
//             break;
//           }
//       }
//
//       // bool isSend = await showModalBottomSheet(
//       //   context: Get.context!,
//       //   isScrollControlled: true,
//       //   enableDrag: true,
//       //   backgroundColor: Colors.transparent,
//       //   isDismissible: false,
//       //   builder: (BuildContext context) => BuildShowImageWidget(
//       //     controller: this,
//       //     file: file,
//       //     isVideo: isVideo,
//       //   ),
//       // );
//
//       // bool isSend = await showDialog(
//       //   context: Get.context!,
//       //   barrierDismissible: false,
//       //   builder: (BuildContext context) => AlertDialog(
//       //     contentPadding: EdgeInsets.zero,
//       //     backgroundColor: Colors.transparent,
//       //     content: BuildShowImageWidget(
//       //       controller: this,
//       //       file: file,
//       //       isVideo: isVideo,
//       //     ),
//       //   ),
//       // );
//
//       // if (isSend) {
//       uploadFile(
//         file: file,
//       );
//       // }
//     }
//   }
//
//   uploadFile({required File file}) async {
//     // ApiResult result = await RequestsUtil.instance.uploadLiveFile(
//     //   file: file,
//     // );
//
//
//     // if(result.isDone){
//     //   print(result.data);
//     // }
//   }
//
//   Widget _tools() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: (muted) ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: (muted) ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: _onCallEnded,
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(24.0),
//             child: const Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 20.0,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: _onToggleCameraOff,
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: (camera) ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//             child: Icon(
//               camera ? Icons.videocam_off_outlined : Icons.videocam_outlined,
//               color: (camera) ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: _onToggleSwitchCamera,
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: (switched) ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//             child: Icon(
//               switched ? Icons.switch_camera_outlined : Icons.switch_camera_outlined,
//               color: (switched) ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.broadCast!) {
//       list.add(const RtcLocalView.SurfaceView());
//     }
//     _users.forEach((int uid) {
//       list.add(RtcRemoteView.SurfaceView(
//         channelId: 'aminroom400',
//         uid: uid,
//       ));
//     });
//     setState(() {});
//     return list;
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//
//     switch (views.length) {
//       case 1:
//         return Column(
//           children: <Widget>[_videoView(views[0])],
//         );
//       case 2:
//         return Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]])
//           ],
//         );
//       case 3:
//         return Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         );
//       case 4:
//         return Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         );
//       default:
//     }
//     return Container();
//   }
//
//   List<Widget> _getRenderRtcChannelViews() {
//     final List<StatefulWidget> list = [];
//     _users2.forEach(
//       (int uid) => list.add(
//         RtcRemoteView.SurfaceView(
//           uid: uid,
//           channelId: 'aminroom400',
//           renderMode: VideoRenderMode.FILL,
//         ),
//       ),
//     );
//     return list;
//   }
//
//   /// Video layout wrapper
//   Widget _viewRtcRows() {
//     final views = _getRenderRtcChannelViews();
//     if (views.isNotEmpty) {
//       print("NUMBER OF VIEWS : ${views.length}");
//       return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: views.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Align(
//             alignment: Alignment.bottomCenter,
//             child: SizedBox(
//                 height: 200,
//                 width: MediaQuery.of(context).size.width * 0.25,
//                 child: _videoView(views[index])),
//           );
//         },
//       );
//     } else {
//       return Align(
//         alignment: Alignment.bottomCenter,
//         child: Container(),
//       );
//     }
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine!.muteLocalAudioStream(muted);
//   }
//
//   void _onToggleSwitchCamera() {
//     setState(() {
//       switched = !switched;
//     });
//     _engine!.switchCamera();
//   }
//
//   void _onToggleCameraOff() {
//     setState(() {
//       camera = !camera;
//     });
//     _engine!.muteLocalVideoStream(camera);
//   }
//
//   void _onCallEnded() {
//     Navigator.pop(context);
//   }
//
//   void showUsers() async {
//     var user = await showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: false,
//       enableDrag: false,
//       builder: (BuildContext context) => UsersOnLiveModal(sub: subscribersList),
//     );
//
//     if (user is UserModel) {
//       addToLive(
//         user: user,
//       );
//     }
//   }
//
//   void addToLive({
//     required UserModel user,
//   }) async {
//     EasyLoading.show();
//     ApiResult result = await RequestsUtil.instance.addNewSubscribeToLive(
//       fcmToken: user.fcmToken!,
//     );
//     if (result.isDone) {
//       Future.delayed(Duration(seconds: 3), () {
//         EasyLoading.dismiss();
//       });
//     }
//   }
// }
