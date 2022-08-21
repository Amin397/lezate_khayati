import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:janus_client/janus_client.dart';
import 'package:lezate_khayati/Models/user_model.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';

import '../../Utils/Live/Helper.dart';
import '../../Utils/Live/conf.dart';

class LiveController extends GetxController {
  RxBool showUsers = false.obs;
  wbrtc.MediaStream? myStream;
  int myRoom = 1234;
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

  Future<void> joinRoom() async {
    var devices = await wbrtc.navigator.mediaDevices.enumerateDevices();
    Map<String, dynamic> constrains = {};
    // print(devices.first.label);
    // print(devices.first.groupId);
    // print("device id" + devices.first.deviceId);
    // print(devices.first.kind);

    devices.map((e) => e.kind.toString()).forEach((element) {
      String dat = element.split('input')[0];
      dat = dat.split('output')[0];
      constrains.putIfAbsent(dat, () => true);
    });
    myStream =
        await plugin.initializeMediaDevices(mediaConstraints: constrains);
    RemoteStream mystr = RemoteStream('0');
    await mystr.init();
    mystr.videoRenderer.srcObject = myStream;
    // setState(() {
    remoteStreams.putIfAbsent(0, () => mystr);
    // });
    // await plugin.initializeWebRTCStack();
    await plugin.joinPublisher(myRoom, displayName: displayname);
    plugin.typedMessages?.listen((event) async {
      Object data = event.event.plugindata?.data;
      // print(data);
      // print('------------------ listen ------------------');
      // print(feedStreams.entries.map((e) => e.value).toList().length);
      // print(subscriptions.entries.map((e) => e.value).toList().length);
      // print(feeds.entries.map((e) => e.value).toList().length);
      // print(subStreams.entries.map((e) => e.value).toList().length);
      // for (int i = 0;
      //     i < subStreams.entries.map((e) => e.value).toList().length;
      //     i++) {
      //   print(subStreams.entries.map((e) => e.value).toList()[i]);
      // }
      // print(mediaStreams.entries.map((e) => e.value).toList().length);
      // print('------------------------------------');

      if (data is VideoRoomJoinedEvent) {
        print(
            'AAAAAAAAAAAAAAAAAAAMMMMMMMMMMMMMMMMMMMIIIIIIIIIIIIIINNNNNNNNNN${subStreams.length}');
        // print('------------------1------------------');

        (await plugin.publishMedia(bitrate: 3000000));
        List<Map<String, dynamic>> publisherStreams = [];
        for (Publishers publisher in data.publishers ?? []) {
          for (Streams stream in publisher.streams ?? []) {
            feedStreams[publisher.id!] = {
              "id": publisher.id,
              "display": publisher.display,
              "streams": publisher.streams,
            };
            publisherStreams.add({"feed": publisher.id, ...stream.toJson()});
            if (publisher.id != null && stream.mid != null) {
              subStreams[stream.mid!] = {
                "id": publisher.id,
                "display": publisher.display,
                "streams": publisher.streams,
                "name": displayname,
                "img": imageAvatar,
                "userId": userId
              };
              // print("substreams is:");
              // print(subStreams);
            }
          }
        }
        subscribeTo(publisherStreams);
      }
      if (data is VideoRoomNewPublisherEvent) {
        // print('------------------2------------------');

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
        // print('got new publishers');
        // print(publisherStreams);
        // subscribeTo(publisherStreams);
      }
      if (data is VideoRoomLeavingEvent) {
        // print('publisher is leaving');
        // print('------------------3------------------');
        //
        // print(data.leaving);
        unSubscribeStream(data.leaving!);
      }
      if (data is VideoRoomConfigured) {
        // print('------------------4------------------');
        //
        // print('typed event with jsep' + event.jsep.toString());
        await plugin.handleRemoteJsep(event.jsep);
      } else {
        // print('------------------${data.runtimeType}------------------');
        // print('------------------4------------------');
      }
      refresh();
      update(['live']);
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
    refresh();
    update(['live']);
    Future.delayed(Duration(seconds: 15), () {
      refresh();
      update(['live']);
    });
  }

  Future<void> unSubscribeStream(int id) async {
// Unsubscribe from this publisher
    var feed = this.feedStreams[id];
    if (feed == null) return;
    this.feedStreams.remove(id);
    await remoteStreams[id]?.dispose();
    remoteStreams.remove(id);
    wbrtc.MediaStream? streamRemoved = this.mediaStreams.remove(id);
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
  }

  subscribeTo(List<Map<String, dynamic>> sources) async {
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

      print('listened');
      if (data is VideoRoomAttachedEvent) {
        print('Attached event');
        data.streams?.forEach((element) {
          if (element.mid != null && element.feedId != null) {
            subStreams[element.mid!]['id'] = element.feedId!;
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
      print('listened2');
      String mid = event.mid!;
      if (subStreams[mid]['id'] != null) {
        int feedId = subStreams[mid]['id']!;
        if (!remoteStreams.containsKey(feedId)) {
          RemoteStream temp = RemoteStream(feedId.toString());
          await temp.init();
          // setState(() {
          remoteStreams.putIfAbsent(feedId, () => temp);
          // });
        }
        if (event.track != null && event.flowing == true) {
          remoteStreams[feedId]?.video.addTrack(event.track!);
          remoteStreams[feedId]?.videoRenderer.srcObject =
              remoteStreams[feedId]?.video;
          // if (kIsWeb) {
          remoteStreams[feedId]?.videoRenderer.muted = false;
          // }
        }
      }
    });
    update(['live']);
    refresh();
    return;
  }

  initialize() async {
    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    j = JanusClient(transport: ws, isUnifiedPlan: true, iceServers: [
      RTCIceServer(
        urls: "stun:stun1.l.google.com:19302",
        username: "",
        credential: "",
      )
    ]);
    session = await j.createSession();

    print('session Id : ${session.sessionId}');
    plugin = await session.attach<JanusVideoRoomPlugin>();
/*    await plugin.createRoom(myRoom,);
    print('room created');*/
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('*****************************');
      if (message.data['title'] == 'کنفرانس') {
        getUsers();
      }
    });

    initialize();

    if (Get.arguments != null) {
      liveId = Get.arguments['liveId'].toString();
      Future.delayed(Duration(seconds: 3), () {
        joinRoom();
      });
    } else {
      joinRoom();
    }
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
}
