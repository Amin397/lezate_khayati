// import 'package:agora_rtc_engine/rtc_channel.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:lezate_khayati/Globals/Globals.dart';
// import 'package:lezate_khayati/Plugins/get/get.dart';
//
// import '../../Models/user_model.dart';
// import '../../Utils/Api/project_request_utils.dart';
// import '../../Utils/Consts.dart';
//
// class LobbyController extends GetxController {
//   RxBool isPublisher = false.obs;
//   RxBool muted = false.obs;
//
//   static final users = <int>[];
//   static final users2 = <int>[];
//
//   final infoStrings = <String>[];
//   List<UserModel> subscribersList = [];
//   String liveId = '0';
//   RtcEngine? engine;
//   RtcChannel? channel;
//
//   @override
//   void onClose() {
//     users.clear();
//     users2.clear();
//     engine!.leaveChannel();
//     engine!.destroy();
//     channel!.leaveChannel();
//     channel!.destroy();
//     super.onClose();
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     if (Get.arguments != null) {
//       liveId = Get.arguments['liveId'].toString();
//     }
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('*****************************');
//       if (message.data['title'] == 'کنفرانس') {
//         if (isPublisher.isTrue) {
//           getUsers();
//         }
//       }
//     });
//
//     // onClose();
//     initialize();
//   }
//
//   Future<void> initialize() async {
//
//
//     isPublisher(Globals.userStream.user!.role == 'admin');
//     print('isPublisher ${isPublisher.value}');
//     engine = await RtcEngine.create(appId);
//     await engine!.enableVideo();
//     await engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     _addAgoraEventHandlers();
//     await engine!.joinChannel(token, 'khayati1', null, 0);
//
//     channel = await RtcChannel.create('khayati1');
//     addRtcChannelEventHandlers();
//     if (isPublisher.isTrue) {
//       print('PPPPPPPPPPPPPPPPPPPPPPP');
//       await engine!.setClientRole(ClientRole.Broadcaster);
//     } else {
//       await engine!.setClientRole(ClientRole.Audience);
//     }
//     await channel!.joinChannel(
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
//   void _addAgoraEventHandlers() {
//     engine!.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         final info = 'onError: $code';
//         infoStrings.add(info);
//         update(['live']);
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         infoStrings.add(info);
//         update(['live']);
//       },
//       leaveChannel: (stats) {
//         infoStrings.add('onLeaveChannel');
//         users.clear();
//         update(['live']);
//       },
//       userJoined: (uid, elapsed) {
//         final info = 'userJoined: $uid';
//         infoStrings.add(info);
//         users.add(uid);
//         update(['live']);
//       },
//       userOffline: (uid, reason) {
//         final info = 'userOffline: $uid , reason: $reason';
//         infoStrings.add(info);
//         users.remove(uid);
//         update(['live']);
//       },
//     ));
//   }
//
//   void addRtcChannelEventHandlers() {
//     channel!.setEventHandler(RtcChannelEventHandler(
//       error: (code) {
//         infoStrings.add('Rtc Channel onError: $code');
//         update(['live']);
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         final info = 'Rtc Channel onJoinChannel: $channel, uid: $uid';
//         infoStrings.add(info);
//         update(['live']);
//       },
//       leaveChannel: (stats) {
//         infoStrings.add('Rtc Channel onLeaveChannel');
//         users2.clear();
//         update(['live']);
//       },
//       userJoined: (uid, elapsed) {
//         final info = 'Rtc Channel userJoined: $uid';
//         infoStrings.add(info);
//         users2.add(uid);
//         update(['live']);
//       },
//       userOffline: (uid, reason) {
//         final info = 'Rtc Channel userOffline: $uid , reason: $reason';
//         infoStrings.add(info);
//         users2.remove(uid);
//         update(['live']);
//       },
//     ));
//   }
//
//   List<Widget> getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (isPublisher.isTrue) {
//       list.add(const RtcLocalView.SurfaceView());
//     }
//     users.forEach((int uid) {
//       list.add(RtcRemoteView.SurfaceView(
//         channelId: 'khayati1',
//         uid: uid,
//       ));
//     });
//     return list;
//   }
//
//   void onToggleMute() {
//     muted(!muted.value);
//     engine!.muteLocalAudioStream(muted.value);
//   }
//
//   void onCallEnded() {
//     // Navigator.pop(context);
//     Get.back();
//   }
//
//   List<Widget> getRenderRtcChannelViews() {
//     final List<StatefulWidget> list = [];
//     users2.forEach(
//       (int uid) => list.add(
//         RtcRemoteView.SurfaceView(
//           uid: uid,
//           channelId: 'khayati1',
//           renderMode: VideoRenderMode.FILL,
//         ),
//       ),
//     );
//     update(['live']);
//     return list;
//   }
//
//   getUsers() async {
//     ApiResult result = await RequestsUtil.instance.getLiveJoinedUser(
//       liveId: liveId,
//     );
//     if (result.isDone) {
//       for (var o in result.data) {
//         // print(o['user']);
//         subscribersList.add(UserModel.fromJson(o['user']));
//       }
//       // subscribersList = UserModel.listFromJsonLive(result.data);
//       update(['live']);
//     }
//   }
//
//
//   @override
//   void dispose() {
//     onClose();
//     super.dispose();
//   }
// }
