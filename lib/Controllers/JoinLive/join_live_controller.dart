import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:janus_client/janus_client.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';
import '../../Views/JoinLive/Widgets/build_invite_alert.dart';

class JoinLiveController extends GetxController {
  // bool justShowLive = true;
  late JanusClient j;
  Map<int, RemoteStream> remoteStreams = {};
  String displayname = 'display name';
  String imageAvatar = 'https://i.pravatar.cc/300';
  String userId = '45454545';
  late RestJanusTransport rest;
  late WebSocketJanusTransport ws;
  wbrtc.MediaStream? myStream;

  late JanusSession session;
  late JanusVideoRoomPlugin plugin;
  JanusVideoRoomPlugin? remoteHandle;
  late int myId;

  int myRoom = 5678;
  Map<int, dynamic> feedStreams = {};
  Map<int?, dynamic> subscriptions = {};
  Map<int, dynamic> feeds = {};
  Map<String, dynamic> subStreams = {};
  Map<int, wbrtc.MediaStream?> mediaStreams = {};
  wbrtc.MediaStream? myStream2;

  // LiveController liveController = Get.put(LiveController());

  initialize() async {
    print('----------------initializing------------------------');

    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    j = JanusClient(transport: ws, isUnifiedPlan: true, iceServers: [
      RTCIceServer(
          urls: "stun:stun1.l.google.com:19302", username: "", credential: "")
    ]);
    session = await j.createSession();
    plugin = await session.attach<JanusVideoRoomPlugin>();

    // subscribeToRoom();

    var response= await  plugin.send(data: {
      "request" : "listparticipants",
      "room" : myRoom
    });

    print(response['plugindata']);
    print(response['plugindata']['data']['participants']);
    List<Map<String, dynamic>> list=[];
    var responseList=response['plugindata']['data']['participants'];
    for(int i=0;i<responseList.length;i++){
      list.add({'mid':'$i','feed':responseList[i]['id']});
    }
    subscribeTo(list);


    print('----------------------------------');
    plugin.onData?.listen((event) {

      print('---------------------  on data ${event}');

    });
    var roooms= await  plugin.send(data: {
      "request" : "list",

    });
    print('rooms ${roooms}');

    plugin.messages?.listen((event) {
      print('---------------------  messages ${event}');
/*      TypedEvent<JanusEvent> typedEvent = TypedEvent<JanusEvent>(
          event: JanusEvent.fromJson(event.event), jsep: event.jsep);
      print(typedEvent.event.plugindata?.data);
      print('---------------------  messages ${event}');*/

      // var data=  event.event.plugindata?.data;
      /*     if(event is EventMessage){

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
      }*/

    });






  }

  subscribeTo(List<Map<String, dynamic>> sources) async {
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
            update(['joinLive']);
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
      update(['joinLive']);
    await plugin.joinPublisher(myRoom, displayName: "Shivansh");

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
  }

  callEnd() async {
    await plugin.hangup();
    for (int i = 0; i < feedStreams.keys.length; i++) {
      await unSubscribeStream(feedStreams.keys.elementAt(i));
    }
    // remoteStreams.forEach((key, value) async {
    //   value.dispose();
    // });
    // setState(() {
    remoteStreams = {};
    // });
    subStreams.clear();
    subscriptions.clear();
    // stop all tracks and then dispose

    await plugin.dispose();
    await remoteHandle?.dispose();


    // joinToChat();
    log('jooooooooooooon to room as publisher');
    joinToChat();
    // liveController.joinRoom();
  }
  endCallAndExit() async {
    await plugin.hangup();
    for (int i = 0; i < feedStreams.keys.length; i++) {
      await unSubscribeStream(feedStreams.keys.elementAt(i));
    }
    remoteStreams.forEach((key, value) async {
      value.dispose();
    });
    // setState(() {
    remoteStreams = {};
    // });
    subStreams.clear();
    subscriptions.clear();
    // stop all tracks and then dispose

    await plugin.dispose();
    await remoteHandle?.dispose();


    // joinToChat();
    log('jooooooooooooon to room as publisher');
    // joinToChat();
    Get.back();
    // liveController.joinRoom();
  }

  @override
  void onInit() {
    print('----------------------- On init called ------------------------');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('88888888888888888888888888888888');
      if (message.data['title'] == 'کنفرانس') {
        showInviteAlert();
        // getUsers();
      }
    });

    initialize();
    Future.delayed(Duration(seconds: 3), () {
      joinRoom();
    });
    super.onInit();
  }

/*  Future<void> joinToChat() async {
    var devices = await wbrtc.navigator.mediaDevices.enumerateDevices();
    Map<String, dynamic> constrains = {};
    print(devices.first.label);
    print(devices.first.groupId);
    print("device id" + devices.first.deviceId);
    print(devices.first.kind);

    devices.map((e) => e.kind.toString()).forEach((element) {
      String dat = element.split('input')[0];
      dat = dat.split('output')[0];
      constrains.putIfAbsent(dat, () => true);
    });
    myStream2 =
        await plugin.initializeMediaDevices(mediaConstraints: constrains);
    RemoteStream mystr = RemoteStream('0');
    await mystr.init();
    mystr.videoRenderer.srcObject = myStream2;
    // setState(() {
    remoteStreams.putIfAbsent(0, () => mystr);
    // });
    await plugin.joinPublisher(myRoom, displayName: displayname);
    plugin.typedMessages?.listen((event) async {
      print('AAAAAAAAAAAAAAAAAAAMMMMMMMMMMMMMMMMMMMIIIIIIIIIIIIIINNNNNNNNNN');
      Object data = event.event.plugindata?.data;
      print(data);
      print('------------------ listen ------------------');
      print('------------------ ${data.runtimeType} ------------------');
      print(feedStreams.entries.map((e) => e.value).toList().length);
      print(subscriptions.entries.map((e) => e.value).toList().length);
      print(feeds.entries.map((e) => e.value).toList().length);
      print(subStreams.entries.map((e) => e.value).toList().length);
      for (int i = 0;
          i < subStreams.entries.map((e) => e.value).toList().length;
          i++) {
        print(subStreams.entries.map((e) => e.value).toList()[i]);
      }
      print(mediaStreams.entries.map((e) => e.value).toList().length);
      print('------------------------------------');

      if (data is VideoRoomJoinedEvent) {
        print('------------------1------------------');

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
              print("substreams is:");
              print(subStreams);
            }
          }
        }
        subscribeTo(publisherStreams);
      }
      if (data is VideoRoomNewPublisherEvent) {
        print('------------------2------------------');

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
        // subscribeTo(publisherStreams);
      }
      if (data is VideoRoomLeavingEvent) {
        print('publisher is leaving');
        print('------------------3------------------');

        print(data.leaving);
        unSubscribeStream(data.leaving!);
      }
      if (data is VideoRoomConfigured) {
        print('------------------4------------------');

        print('typed event with jsep' + event.jsep.toString());
        await plugin.handleRemoteJsep(event.jsep);
      } else {
        print('------------------${data.runtimeType}------------------');
        // print('------------------4------------------');
      }
      refresh();
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });

    update(['joinLive']);
    Future.delayed(Duration(seconds: 5), () {
      update(['joinLive']);
    });


  }*/

  Future<void> joinToChat() async {
    var devices = await wbrtc.navigator.mediaDevices.enumerateDevices();
    Map<String, dynamic> constrains = {};
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
    await plugin.joinPublisher(myRoom, displayName: "Shivansh");
    print('----------------------------------------');
    plugin.typedMessages?.listen((event) async {
      Object data = event.event.plugindata?.data;
      if (data is VideoRoomJoinedEvent) {
        (await plugin.publishMedia(bitrate: 3000000));
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
        update(['live']);
        subscribeTo(publisherStreams);
        update(['live']);
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
        update(['live']);
      }
      if (data is VideoRoomLeavingEvent) {
        print('publisher is leaving');
        print(data.leaving);
        unSubscribeStream(data.leaving!);
        update(['live']);
      }
      if (data is VideoRoomConfigured) {
        print('typed event with jsep' + event.jsep.toString());
        await plugin.handleRemoteJsep(event.jsep);
        update(['live']);
      }
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });
    update(['live']);
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose called');
    await remoteHandle?.dispose();
    await plugin.dispose();
    Get.delete<JoinLiveController>();
    session.dispose();

    ws.dispose();
    myStream?.dispose();


    remoteStreams.forEach((key, value) {
      value.dispose();
    });    feedStreams.forEach((key, value) {
      value?.dispose();
    });
    subStreams.forEach((key, value) {
      value?.dispose();
    }); mediaStreams.forEach((key, value) {
      value?.dispose();
    });
     myStream2?.dispose();
  }

  void showInviteAlert() async {
    print('-------------------------- show dialog -------------------');
    bool accept = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: BuildInviteAlert(),
      ),
    );

    if(accept){
      joinToChat();
    //  callEnd();
      // LiveController liveController = Get.put(LiveController());
    //  joinToChat();
    }
  }
}
