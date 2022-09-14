import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:janus_client/janus_client.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Utils/Api/project_request_utils.dart';
import 'package:lottie/lottie.dart';

// import '../../Plugins/get/get.dart';
import '../../Models/Live/comment_model.dart';
import '../../Plugins/get/get.dart' as gets;
import '../../Utils/Consts.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';
import '../../Utils/view_utils.dart';
import '../Live/Widgets/show_uploaded_image_modal.dart';

class TypedVideoRoomV3Unified extends StatefulWidget {
  @override
  _VideoRoomState createState() => _VideoRoomState();
}

class _VideoRoomState extends State<TypedVideoRoomV3Unified>
    with TickerProviderStateMixin {
  late JanusClient j;
  Map<int, RemoteStream> remoteStreams = {};
  String displayname = 'mohammad';
  String imageAvatar = 'https://i.pravatar.cc/300';
  String userId = '45454545';
  late RestJanusTransport rest;
  late WebSocketJanusTransport ws;
  late JanusSession session;
  late JanusVideoRoomPlugin plugin;
  JanusVideoRoomPlugin? remoteHandle;
  late int myId;
  Timer? timeer;
  List<Map<String, dynamic>> list=[];
  List<CommentModel> commentsList = [];
  late final AnimationController animationController;
  bool isLoaded = false;
  int myRoom = 1234;
  Map<int, dynamic> feedStreams = {};
  Map<int?, dynamic> subscriptions = {};
  Map<int, dynamic> feeds = {};
  Map<String, dynamic> subStreams = {};
  Map<int, MediaStream?> mediaStreams = {};
  final ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  String? uploadImage;

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




  Future<void> initialize() async {
    ws = WebSocketJanusTransport(url: servermap['janus_ws']);
    j = JanusClient(transport: ws, isUnifiedPlan: true, iceServers: [
      RTCIceServer(
          urls: "stun:stun1.l.google.com:19302", username: "", credential: "")
    ]);
    session = await j.createSession();
    print('session Id : ${session.sessionId}');
    plugin = await session.attach<JanusVideoRoomPlugin>();
    timeer = Timer.periodic(Duration(seconds: 10), (timer) async {

      await _checkUpdates();
    });

  }


  _checkUpdates()async{
    print('------------------- call fun in timer');
    try {
      var response = await plugin.send(data: {
        "request": "listparticipants",
        "room": myRoom
      }); /*   var response2= await  plugin.send(data: {
      "request" : "list"
    });
    print('[videoRoom]');
    print(response2);*/


      print(response['plugindata']);
      print(response['plugindata']['data']['participants']);
      List<Map<String, dynamic>> temList = [];

      var responseList = response['plugindata']['data']['participants'];
      for (int i = 0; i < responseList.length; i++) {
        if (responseList[i]['display'] == 'mohammad') {
          temList.add({'mid': '$i', 'feed': responseList[i]['id']});
          print(responseList[i]);
        }
      }
      print('new list length ${temList.length}');
      print('remote streem length ${remoteStreams.length}');
      print('old list length ${list.length}');
      if (remoteStreams.length == 0 ) {
        list.clear();
        print('remote stream cleaned');
      }
      if( remoteStreams.length>temList.length){

        gets.Get.back();

        print('--------------------we return back soon--------------------');
        gets.Get.to( ()=>TypedVideoRoomV3Unified());
      }
      if (temList.length != list.length) {
        list = List.from(temList);
        print('run subs to');

        subscribeTo(list);
        if (list.isEmpty) {
          callEnd();
        }
      }
    }catch(e){
      print('[VideoROOM] $e');

      gets.Get.back();

      print('--------------------hhhh--------------------');
      gets.Get.to( ()=>TypedVideoRoomV3Unified());
    }
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
    var start = await remoteHandle?.joinSubscriber(myRoom, feedId: streams[0].feed);
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
      setState(() {
        isLoaded = true;
      });
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

    // setState(() {
    //   isLoaded = true;
    // });
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
  void initState() {
    getComments();
    animationController = AnimationController(
      vsync: this,
    );
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('*****************************');
      if (message.data['title'] == 'comment') {
        // getComments();
        print(message.data['message'].runtimeType);
        setState(() {
          commentsList
              .add(CommentModel.fromJson(jsonDecode(message.data['message'])));
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 50,
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.easeInOut,
          );
        });
      } else if(message.data['type'] == 'live_img'){
        setState(() {
          uploadImage = message.data['live_img'];
        });
      }
    });
  }

  getComments() async {
    commentsList.clear();
    ApiResult result = await RequestsUtil.instance.getComments(
      liveId: Globals.liveStream.liveId,
    );
    if (result.isDone) {
      setState(() {
        commentsList = CommentModel.listFromJson(result.data);
      });
    }
  }

  @override
  void dispose() async {
    super.dispose();
    timeer?.cancel();
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


  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('ویدئو کنفرانس'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // showUsers.value = true;
              timeer?.cancel();

              Navigator.of(context).pop();
              // Get.back();
            },
            icon: Icon(Icons.call_end),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (isLoaded)
            ? Stack(
                children: [
                  _buildPublisherView(),
                  _buildCommentPart(),
                  (uploadImage is String)?Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        showModal();
                      },
                      child: Container(
                        height: size!.height * .05,
                        width: size!.width * .3,
                        margin: paddingAll10,
                        decoration: BoxDecoration(
                          borderRadius: radiusAll6,
                          color: Colors.white,
                          boxShadow: ViewUtils.neoShadow(),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            'نمایش تصویر',
                            maxFontSize: 16.0,
                            maxLines: 1,
                            minFontSize: 12.0,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):SizedBox(),
                ],
              )
            : Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
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
      ),
    );
  }


  void showModal() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      useRootNavigator: false,
      builder: (BuildContext context) => ShowUploadedImageModal(
        isSub: true,
        imageLink: uploadImage,
      ),
    );
  }


  Widget _buildPublisherView() {
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
          RTCVideoView(
            remoteStream.audioRenderer,
            filterQuality: FilterQuality.medium,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: true,
          ),
          RTCVideoView(
            remoteStream.videoRenderer,
            filterQuality: FilterQuality.medium,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentPart() {
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
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCommentItem(
                      comment: commentsList[index],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: paddingAll8,
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * .06,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .15,
                      ),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        // boxShadow: ViewUtils.shadow(
                        //   offset: const Offset(0.0, 0.0),
                        // ),
                        borderRadius: radiusAll10,
                      ),
                      duration: const Duration(milliseconds: 270),
                      child: TextField(
                        onTap: () {
                          // controller.scrollToDown();
                        },
                        controller: messageController,
                        maxLines: 10,
                        minLines: 1,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: radiusAll10,
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radiusAll10,
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'متن پیام',
                          hintStyle: TextStyle(
                            fontSize: 12.0,
                          ),
                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     controller.pickFile();
                          //   },
                          //   icon: Icon(
                          //     Icons.attach_file,
                          //     color: Colors.grey.shade700,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    child: Lottie.asset(
                      'assets/animations/send.json',
                      height: MediaQuery.of(context).size.width * .15,
                      width: MediaQuery.of(context).size.width * .15,
                      controller: animationController,
                      // repeat: false,
                    ),
                  ),
                ],
              ),
            )
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
      liveId: Globals.liveStream.liveId,
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
            liveId: Globals.liveStream.liveId,
          ),
        );
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 50,
          duration: const Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}
