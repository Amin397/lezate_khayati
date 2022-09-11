import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:janus_client/janus_client.dart';

import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';

class TypedVideoRoomV3Unified extends StatefulWidget {
  @override
  _VideoRoomState createState() => _VideoRoomState();
}

class _VideoRoomState extends State<TypedVideoRoomV3Unified> {
  late JanusClient j;
  Map<int, RemoteStream> remoteStreams = {};
  String displayname = 'display name';
  String imageAvatar = 'https://i.pravatar.cc/300';
  String userId = '45454545';
  late RestJanusTransport rest;
  late WebSocketJanusTransport ws;
  late JanusSession session;
  late JanusVideoRoomPlugin plugin;
  JanusVideoRoomPlugin? remoteHandle;
  late int myId;

  int myRoom = 1234;
  Map<int, dynamic> feedStreams = {};
  Map<int?, dynamic> subscriptions = {};
  Map<int, dynamic> feeds = {};
  Map<String, dynamic> subStreams = {};
  Map<int, MediaStream?> mediaStreams = {};

  //todo: create a session and join as publisher ✓
  //todo: send sesion id to all users ✓
  //todo: see this sesion all users as player ✓
  //todo: show one user as publisher
  //todo: show image in this screen
  //todo: delete user as publisher

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    initialize();
  }

  initialize() async {
    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    j = JanusClient(transport: ws, isUnifiedPlan: true, iceServers: [
      RTCIceServer(
          urls: "stun:stun1.l.google.com:19302", username: "", credential: "")
    ]);
    session = await j.createSession();
    print('session Id : ${session.sessionId}');
    plugin = await session.attach<JanusVideoRoomPlugin>();
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
    var devices = await navigator.mediaDevices.enumerateDevices();
    Map<String, dynamic> constrains = {};
    print(devices.first.label);
    print(devices.first.groupId);
    print(devices.first.deviceId);
    print(devices.first.kind);

    devices.map((e) => e.kind.toString()).forEach((element) {
      String dat = element.split('input')[0];
      dat = dat.split('output')[0];
      constrains.putIfAbsent(dat, () => true);
    });

    RemoteStream mystr = RemoteStream('1');
    // await mystr.init();
    //
    // setState(() {
    //   remoteStreams.putIfAbsent(0, () => mystr);
    // });
    await plugin.joinPublisher(myRoom, displayName: displayname);
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

    await plugin.dispose();
    await remoteHandle?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.greenAccent,
              ),
              onPressed: () async {
                await this.joinRoom();
              }),
          IconButton(
              icon: Icon(
                Icons.flip_camera_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () async {
                await callEnd();
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: remoteStreams.entries
                          .map((e) => e.value)
                          .toList()
                          .length ==
                      1
                  ? ListView.builder(
                      itemCount: remoteStreams.entries
                          .map((e) => e.value)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        List<RemoteStream> items =
                            remoteStreams.entries.map((e) => e.value).toList();
                        print('items length -----------> ${items.length}');
                        RemoteStream remoteStream = items[index];
                        print(
                            'items length -----------> ${remoteStream.videoRenderer}');
                        print(
                            'items length -----------> ${remoteStream.audioRenderer}');

                        return Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: [
                              RTCVideoView(remoteStream.audioRenderer,
                                  filterQuality: FilterQuality.medium,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true),
                              RTCVideoView(remoteStream.videoRenderer,
                                  filterQuality: FilterQuality.medium,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true)
                            ],
                          ),
                        );
                      })
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: remoteStreams.entries
                          .map((e) => e.value)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        List<RemoteStream> items =
                            remoteStreams.entries.map((e) => e.value).toList();
                        print('items length -----------> ${items.length}');
                        RemoteStream remoteStream = items[index];
                        print(
                            'items length -----------> ${remoteStream.videoRenderer}');
                        print(
                            'items length -----------> ${remoteStream.audioRenderer}');

                        return Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: [
                              RTCVideoView(remoteStream.audioRenderer,
                                  filterQuality: FilterQuality.medium,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true),
                              RTCVideoView(remoteStream.videoRenderer,
                                  filterQuality: FilterQuality.medium,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true)
                            ],
                          ),
                        );
                      },
                    ),
            ),
            //here you shoud show image.network
          ],
        ),
      ),
    );
  }
}
