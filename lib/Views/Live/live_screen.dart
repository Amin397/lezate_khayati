import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:get/get.dart';
import 'package:janus_client/janus_client.dart';

import '../../Models/user_model.dart';
import '../../Utils/Api/project_request_utils.dart';
import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';

class TypedVideoRoomV2Unified extends StatefulWidget {

  TypedVideoRoomV2Unified({this.liveId});

  final int? liveId;

  @override
  _VideoRoomState createState() => _VideoRoomState();

}

class _VideoRoomState extends State<TypedVideoRoomV2Unified> {


  late JanusClient j;
  String displayname = 'display name';
  String imageAvatar = 'https://i.pravatar.cc/300';
  String userId = '45454545';
  Map<int, RemoteStream> remoteStreams = {};

  int subscribersCount = 0;
  late RestJanusTransport rest;
  late WebSocketJanusTransport ws;
  late JanusSession session;
  late JanusVideoRoomPlugin plugin;
  JanusVideoRoomPlugin? remoteHandle;
  late int myId;
  wbrtc.MediaStream? myStream;
  RxBool showUsers = false.obs;
  int myRoom = 1234;
  Map<int, dynamic> feedStreams = {};
  Map<int?, dynamic> subscriptions = {};
  Map<int, dynamic> feeds = {};
  Map<String, dynamic> subStreams = {};
  Map<int, wbrtc.MediaStream?> mediaStreams = {};

  bool isLoaded = false;

  //todo: create a session and join as publisher ✓
  //todo: send sesion id to all users ✓
  //todo: see this sesion all users as player
  //todo: show one user as publisher
  //todo: show image in this screen
  //todo: delete user as publisher

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    initialize().then((value) => joinRoom());
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('*****************************');
      if (message.data['title'] == 'کنفرانس') {
        getUsers();
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
      setState(() {
        subscribersCount = UserModel.listFromJsonLive(result.data).length;
      });
      // update(['live']);
    }
  }

  Future<void> initialize() async {
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
          setState(() {
            remoteStreams.putIfAbsent(feedId, () => temp);
          });
        }
        if (event.track != null && event.flowing == true) {
          remoteStreams[feedId]?.video.addTrack(event.track!);
          remoteStreams[feedId]?.videoRenderer.srcObject =
              remoteStreams[feedId]?.video;
          if (kIsWeb) {
            remoteStreams[feedId]?.videoRenderer.muted = false;
          }
        }
      }
    });
    return;
  }

  Future<void> joinRoom() async {
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
    myStream =
        await plugin.initializeMediaDevices(mediaConstraints: constrains);
    RemoteStream mystr = RemoteStream('0');
    await mystr.init();
    mystr.videoRenderer.srcObject = myStream;
    setState(() {
      remoteStreams.putIfAbsent(0, () => mystr);
    });
    await plugin.joinPublisher(myRoom, displayName: displayname);
    plugin.typedMessages?.listen((event) async {
      Object data = event.event.plugindata?.data;
      print('------------------ listen ------------------');
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
        subscribeTo(publisherStreams);
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
        print('------------------4------------------');
      }
    }, onError: (error, trace) {
      if (error is JanusError) {
        print(error.toMap());
      }
    });

    setState(() {
      isLoaded = true;
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

  @override
  void dispose() async {
    super.dispose();
    await remoteHandle?.dispose();
    await plugin.dispose();
    session.dispose();
  }

  callEnd() async {
    await plugin.hangup();
    for (int i = 0; i < feedStreams.keys.length; i++) {
      await unSubscribeStream(feedStreams.keys.elementAt(i));
    }
    remoteStreams.forEach((key, value) async {
      value.dispose();
    });
    setState(() {
      remoteStreams = {};
    });
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

  addPublisher() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('ویدئو کنفرانس'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 20.0,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  subscribersCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: (isLoaded)
          ? Stack(
              children: [
                _buildAdminView(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: Get.height * .05,
                    ),
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: FloatingActionButton(
                      heroTag: '9',
                      onPressed: () {
                        // showUsers.value = true;
                        Navigator.of(context).pop();
                        // Get.back();
                      },
                      backgroundColor: Colors.red.shade700,
                      child: Icon(Icons.call_end),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red, //<-- SEE HERE
                      ),
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAdminView() {
    List<RemoteStream> items =
        remoteStreams.entries.map((e) => e.value).toList();
    print('items length -----------> ${items.length}');
    RemoteStream remoteStream = items[0];

    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          wbrtc.RTCVideoView(remoteStream.audioRenderer,
              filterQuality: FilterQuality.medium,
              objectFit: wbrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true),
          wbrtc.RTCVideoView(remoteStream.videoRenderer,
              filterQuality: FilterQuality.medium,
              objectFit: wbrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: true)
        ],
      ),
    );
  }
}
