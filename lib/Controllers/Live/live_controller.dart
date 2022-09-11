import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:janus_client/janus_client.dart';
import 'package:lezate_khayati/Models/user_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';


class LiveController extends GetxController {


  RTCVideoRenderer? myAudioRenderer;
  RTCVideoRenderer? myVideoRenderer;
  RxBool showUsers = false.obs;
  wbrtc.MediaStream? myStream;
  int myRoom = 5678;
  String displayname = 'display name';
  late JanusVideoRoomPlugin plugin;
  Map<int, dynamic> feedStreams = {};
  Map<int?, dynamic> subscriptions = {};
  Map<int, dynamic> feeds = {};
  Map<String, dynamic> subStreams = {};
  Map<int, wbrtc.MediaStream?> mediaStreams = {};
  String imageAvatar = 'https://i.pravatar.cc/300';
  JanusVideoRoomPlugin? remoteHandle;
  Map<int, RemoteStream> remoteStreams = {};
  String userId = '45454545';
  late RestJanusTransport rest;
  late WebSocketJanusTransport ws;
  late JanusSession session;
  late JanusClient j;
  RemoteStream myStr = RemoteStream('0');

  List<UserModel> subscribersList = [];
  String liveId = '0';

  joinSub(List<Map<String, dynamic>> sources) async {
    print('publisheersssss');

    if (sources.length == 0) return;
    var streams = (sources)
        .map((e) => PublisherStream(mid: e['mid'], feed: e['feed']))
        .toList();
    if (remoteHandle != null) {
      await remoteHandle?.subscribeToStreams(streams);
      return;
    }
    remoteHandle = await session.attach<JanusVideoRoomPlugin>();
    print(sources);
    var start = await remoteHandle?.joinSubscriber(myRoom, streams: streams);
    remoteHandle?.typedMessages?.listen((event) async {
      Object data = event.event.plugindata?.data;
      if (data is VideoRoomAttachedEvent) {
        print('Attached event');
        data.streams?.forEach((element) {
          if (element.mid != null && element.feedId != null) {
            subStreams[element.mid!] = element.feedId!;
          }
          // to avoid duplicate subscriptions
          if (subscriptions[element.feedId] == null)
            subscriptions[element.feedId] = {};
          subscriptions[element.feedId][element.mid] = true;
        });
        print('substreams');
        print(subStreams);
      }
      if (event.jsep != null) {
        await remoteHandle?.handleRemoteJsep(event.jsep);
        await start!();
      }
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
    remoteHandle?.remoteTrack?.listen((event) async {
      print(' -------------------------------- listen lisnten');
      String mid = event.mid!;
      if (subStreams[mid] != null) {
        int feedId = subStreams[mid]!;
        if (!remoteStreams.containsKey(feedId)) {
          RemoteStream temp = RemoteStream(feedId.toString());
          await temp.init();
            remoteStreams.putIfAbsent(feedId, () => temp);
            update(['live']);
        }
        if (event.track != null && event.flowing == true) {
          remoteStreams[feedId]?.video.addTrack(event.track!);
          remoteStreams[feedId]?.videoRenderer.srcObject =
              remoteStreams[feedId]?.video;
          // if (kIsWeb) {
          //   remoteStreams[feedId]?.videoRenderer.muted = false;
          // }
        }
      }
    });

    plugin.typedMessages?.listen((event) async {
      print('listener called   ---------------jskfksjdfk');

    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
    return;
  }




  Future<void> joinRoom() async {
    await plugin.initializeMediaDevices();
    RemoteStream mystr = RemoteStream('0');
    await mystr.init();
    mystr.videoRenderer.srcObject = plugin.webRTCHandle!.localStream;
      remoteStreams.putIfAbsent(0, () => mystr);
      update(['live']);
    await plugin.joinPublisher(myRoom, displayName: "Shivansh");
    plugin.typedMessages?.listen((event) async {
      print('listener called');
      Object data = event.event.plugindata?.data;
      if (data is VideoRoomJoinedEvent) {
        (await plugin.publishMedia(bitrate: 3000000,videCodec: 'vp9',audioCodec:"opus" ));
        List<Map<String, dynamic>> publisherStreams = [];
        for (Publishers publisher in data.publishers ?? []) {
          for (Streams stream in publisher.streams ?? []) {
            feedStreams[publisher.id!] = {
              "id": publisher.id,
              "display": publisher.display,
              "streams": publisher.streams
            };
            publisherStreams.add({"feed": publisher.id, ...stream.toJson()});
            if (publisher.id != null && stream.mid != null) {
              subStreams[stream.mid!] = publisher.id!;
              print("substreams is:");
              print(subStreams);
            }
          }
        }
        subscribeTo(publisherStreams);
      }
      if (data is VideoRoomNewPublisherEvent) {
        List<Map<String, dynamic>> publisherStreams = [];
        for (Publishers publisher in data.publishers ?? []) {
          feedStreams[publisher.id!] = {
            "id": publisher.id,
            "display": publisher.display,
            "streams": publisher.streams
          };
          for (Streams stream in publisher.streams ?? []) {
            publisherStreams.add({"feed": publisher.id, ...stream.toJson()});
            if (publisher.id != null && stream.mid != null) {
              subStreams[stream.mid!] = publisher.id!;
              print("substreams is:");
              print(subStreams);
            }
          }
        }
        print('got new publishers');
        print(publisherStreams);
        subscribeTo(publisherStreams);
      }
      if (data is VideoRoomLeavingEvent) {
        print('publisher is leaving');
        print(data.leaving);
        unSubscribeStream(data.leaving!);
      }
      if (data is VideoRoomConfigured) {
        print('typed event with jsep' + event.jsep.toString());
        await plugin.handleRemoteJsep(event.jsep);
      }
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
  }

  Future<void> unSubscribeStream(int id) async {
// Unsubscribe from this publisher
    var feed = this.feedStreams[id];
    if (feed == null) return;
    this.feedStreams.remove(id);
    await remoteStreams[id]?.dispose();
    remoteStreams.remove(id);
    MediaStream? streamRemoved = this.mediaStreams.remove(id);
    streamRemoved?.getTracks().forEach((element) async {
      await element.stop();
    });
    var unsubscribe = {
      "request": "unsubscribe",
      "streams": [
        {feed: id}
      ]
    };
    if (remoteHandle != null)
      await remoteHandle?.send(data: {"message": unsubscribe});
    this.subscriptions.remove(id);
    update(['live']);
  }

  subscribeTo(List<Map<String, dynamic>> sources) async {
    print('publisheersssss');
    print(jsonEncode(sources));
    if (sources.length == 0) return;
    var streams = (sources)
        .map((e) => PublisherStream(mid: e['mid'], feed: e['feed']))
        .toList();
    if (remoteHandle != null) {
      await remoteHandle?.subscribeToStreams(streams);
      return;
    }
    remoteHandle = await session.attach<JanusVideoRoomPlugin>();
    print(sources);
    var start = await remoteHandle?.joinSubscriber(myRoom, streams: streams);
    remoteHandle?.typedMessages?.listen((event) async {

      Object data = event.event.plugindata?.data;
      if (data is VideoRoomAttachedEvent) {
        print('Attached event');
        data.streams?.forEach((element) {
          if (element.mid != null && element.feedId != null) {
            subStreams[element.mid!] = element.feedId!;
          }
          // to avoid duplicate subscriptions
          if (subscriptions[element.feedId] == null)
            subscriptions[element.feedId] = {};
          subscriptions[element.feedId][element.mid] = true;
        });
        print('substreams');
        print(subStreams);
      }
      if (event.jsep != null) {
        await remoteHandle?.handleRemoteJsep(event.jsep);
        await start!();
      }
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
    remoteHandle?.remoteTrack?.listen((event) async {
      String mid = event.mid!;
      if (subStreams[mid] != null) {
        int feedId = subStreams[mid]!;
        if (!remoteStreams.containsKey(feedId)) {
          RemoteStream temp = RemoteStream(feedId.toString());
          await temp.init();
            remoteStreams.putIfAbsent(feedId, () => temp);
            update(['live']);
        }
        if (event.track != null && event.flowing == true) {
          remoteStreams[feedId]?.video.addTrack(event.track!);
          remoteStreams[feedId]?.videoRenderer.srcObject =
              remoteStreams[feedId]?.video;
          // if (kIsWeb) {
          //   remoteStreams[feedId]?.videoRenderer.muted = false;
          // }
        }
      }
    });
    return;
  }

  Future initialize() async {
    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    j = JanusClient(transport: ws, isUnifiedPlan: true, iceServers: [
      RTCIceServer(
          urls: "stun:stun1.l.google.com:19302", username: "", credential: "")
    ]);
    session = await j.createSession();
    plugin = await session.attach<JanusVideoRoomPlugin>();


  }

  callEnd() async {
    await plugin.hangup();
    for (int i = 0; i < feedStreams.keys.length; i++) {
      await unSubscribeStream(feedStreams.keys.elementAt(i));
    }
    remoteStreams.forEach((key, value) async {
      value.dispose();
    });
    remoteStreams = {};
    update(['live']);
    subStreams.clear();
    subscriptions.clear();
    // stop all tracks and then dispose
    myStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await myStream?.dispose();
    await plugin.dispose();
    await remoteHandle?.dispose();
  }

  @override
  void onClose() async {
    await remoteHandle?.dispose();
    await plugin.dispose();
    session.dispose();
    super.onClose();
  }

  @override
  void onInit() {
      liveId = Get.arguments['liveId'].toString();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('*****************************');
      if (message.data['title'] == 'کنفرانس') {
        getUsers();
      }
    });

    initialize().then((value){
        joinRoom();

    });
    
    // if (Get.arguments != null) {
    //   Future.delayed(Duration(seconds: 3), () {
    //     joinRoom();
    //   });
    // } else {
    //   joinRoom();
    // }
    super.onInit();
  }

  getUsers() async {
    ApiResult result = await RequestsUtil.instance.getLiveJoinedUser(
      liveId: liveId,
    );
    if (result.isDone) {
      for (var o in result.data) {
        // print(o['user']);
        subscribersList.add(UserModel.fromJson(o['user']));
      }
      // subscribersList = UserModel.listFromJsonLive(result.data);
      update(['live']);
    }
  }

  void showUsersModal() async {
    showUsers(true);
    // print(subStreams.length);
    // showModalBottomSheet(
    //   backgroundColor: Colors.transparent,
    //   // isDismissible: false,
    //   // enableDrag: false,
    //   // isScrollControlled: false,
    //   context: Get.context!,
    //   builder: (BuildContext context) => SubscribersScreen(
    //     subscripers: subStreams,
    //     callback: () {
    //       showUsers.value = false;
    //     },
    //   ),
    // );
  }

  void addToLive({
    required UserModel user,
  }) async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.addNewSubscribeToLive(
      fcmToken: user.fcmToken!,
    );
    if (result.isDone) {
      Future.delayed(Duration(seconds: 5), () {
        EasyLoading.dismiss();
        showUsers(false);
      });
    }
  }

  void switchCamera() {
    remoteHandle!.switchCamera();
  }
}
