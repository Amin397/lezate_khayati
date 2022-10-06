import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:get/get.dart';
import 'package:janus_client/janus_client.dart';
import 'package:lezate_khayati/Globals/Globals.dart';
import 'package:lezate_khayati/Plugins/get/get_connect/http/src/request/request.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

import '../../Models/Live/comment_model.dart';
import '../../Models/user_model.dart';
import '../../Utils/Api/project_request_utils.dart';
import '../../Utils/Consts.dart';
import '../../Utils/janus-webrtc/Helper.dart';
import '../../Utils/janus-webrtc/conf.dart';
import 'Widgets/comment_part.dart';
import 'Widgets/show_uploaded_image_modal.dart';

class TypedVideoRoomV2Unified extends StatefulWidget {
  TypedVideoRoomV2Unified({this.liveId});

  final int? liveId;

  @override
  _VideoRoomState createState() => _VideoRoomState();
}

class _VideoRoomState extends State<TypedVideoRoomV2Unified>
    with TickerProviderStateMixin {
  late JanusClient j;
  String displayname = 'mohammad';
  String imageAvatar = 'https://i.pravatar.cc/300';
  String userId = '45454545';
  Map<int, RemoteStream> remoteStreams = {};

  List<UserModel> subscribers = [];
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
  final ScrollController scrollController = ScrollController();
  List<CommentModel> commentsList = [];
  List<Map<String, dynamic>> publisherStreams = [];
  bool isLoaded = false;
  File? file;
  late final AnimationController animationController;

  TextEditingController messageController = TextEditingController();

  bool commentsBan = false;

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
    // getComments();
    animationController = AnimationController(
      vsync: this,
    );
    super.initState();
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
        subscribers = UserModel.listFromJsonLive(result.data);
      });
      // update(['live']);
    }
  }

  getComments() async {
    commentsList.clear();
    ApiResult result = await RequestsUtil.instance.getComments(
      liveId: widget.liveId.toString(),
    );
    if (result.isDone) {
      setState(() {
        commentsList = CommentModel.listFromJson(result.data);
      });
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
    myPrint();
    if (sources.length == 0) return;
    var streams = (sources)
        .map((e) => PublisherStream(mid: e['mid'], feed: e['feed']))
        .toList();
    if (remoteHandle != null) {
      await remoteHandle?.subscribeToStreams(streams);
      myPrint();
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
      myPrint();
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

      myPrint();
    });

    myPrint();
    return;
  }

  myPrint() {
    print('888888888888888888888888888888888888888888');
    print('feedStreams ${feedStreams}');
    print('subscriptions ${subscriptions}');
    print(' feeds ${feeds}');
    print('subStreams ${subStreams}');
    print('mediaStreams ${mediaStreams}');
    print('sources ${publisherStreams}');
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

  sendNotife() async {
    print(publisherStreams);
    ApiResult result = await RequestsUtil.instance.sendPublisher(
      // publishers: publisherStreams.toString(),
      publishers: 'await plugin.',
      liveId: widget.liveId.toString(),
    );
    if (result.isDone) {
      print(result.data);
    }
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
        leading: IconButton(
          onPressed: () {
            // showUsers.value = true;
            Navigator.of(context).pop();
            // Get.back();
          },
          icon: Icon(
            Icons.call_end,
          ),
        ),
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
                  subscribers.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (Globals.userStream.user!.role == 'admin')
            IconButton(
              onPressed: () {
                pickFile();
              },
              icon: Icon(Icons.upload_file),
            ),
        ],
      ),
      body: (isLoaded)
          ? Stack(
              children: [
                _buildAdminView(),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     margin: EdgeInsets.only(
                //       bottom: Get.height * .05,
                //     ),
                //     width: MediaQuery.of(context).size.width * 0.65,
                //     child: FloatingActionButton(
                //       heroTag: '9',
                //       onPressed: () {
                //         // showUsers.value = true;
                //         Navigator.of(context).pop();
                //         // Get.back();
                //       },
                //       backgroundColor: Colors.red.shade700,
                //       child: Icon(Icons.call_end),
                //     ),
                //   ),
                // ),
                // _buildCommentPart(),
                _buildCommentToggle(),
                CommentPart(
                  liveId: widget.liveId.toString(),
                ),
                (file is File)
                    ? Align(
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
                      )
                    : SizedBox(),
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

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
      //
      // switch (file!.path.split('.').last) {
      //   case 'png':
      //     {
      //       print('png');
      //       break;
      //     }
      //   case 'jpeg':
      //     {
      //       print('jpeg');
      //       break;
      //     }
      // // case 'mp4':
      // //   {
      // //     file = await getThumb(filePath: file.path);
      // //     isVideo = true;
      // //     print('mp4');
      // //     break;
      // //   }
      //   default:
      //     {
      //       print(file!.path.split('.').last.toString());
      //       break;
      //     }
      // }
      uploadFile(
        file: file!,
      );
      // }
    }
  }

  uploadFile({required File file}) async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.uploadLiveFile(
      file: file,
      liveId: widget.liveId.toString(),
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      print(result.data);
    }
  }

  Widget _buildAdminView() {
    List<RemoteStream> items =
        remoteStreams.entries.map((e) => e.value).toList();
    print('items length -----------> ${items.length}');
    RemoteStream remoteStream = items[0];

    return Container(
      color: Colors.black,
      width: size!.width,
      height: size!.height,
      child: Stack(
        children: [
          wbrtc.RTCVideoView(
            remoteStream.audioRenderer,
            filterQuality: FilterQuality.medium,
            objectFit: wbrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: true,
          ),
          wbrtc.RTCVideoView(
            remoteStream.videoRenderer,
            filterQuality: FilterQuality.medium,
            objectFit: wbrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: true,
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

  void showModal() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      useRootNavigator: false,
      builder: (BuildContext context) => ShowUploadedImageModal(
        file: file!,
        isSub: false,
      ),
    );
  }

  Widget _buildCommentToggle() {
    return Positioned(
      top: 25.0,
      right: 25.0,
      child: ElevatedButton(
        child: Icon((commentsBan)
            ? Icons.comment_outlined
            : Icons.comments_disabled_outlined),
        onPressed: () {
          banComments();
        },
        style: ElevatedButton.styleFrom(
          primary:(commentsBan)? Colors.deepOrange:Colors.grey,
          elevation: 5,
        ),
      ),
    );
  }

  void banComments() async{
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.bannedComments();
    EasyLoading.dismiss();

    if(result.isDone){
      setState(() {
        commentsBan = !commentsBan;
      });
    }
  }
}
