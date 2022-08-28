import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:lezate_khayati/Plugins/get/get.dart';

import '../../Controllers/JoinLive/join_live_controller.dart';
import '../../Utils/Live/Helper.dart';

class JoinLiveScreen extends StatelessWidget {
  JoinLiveScreen({Key? key}) : super(key: key);

  final JoinLiveController controller = Get.put(JoinLiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Container(
        height: Get.height,
        width: Get.width,

        child: GetBuilder<JoinLiveController>(
          id: 'joinLive',
          builder: (ctx) => Column(
            children: [
              Flexible(
                flex: 1,
                child: ctx.remoteStreams.entries
                                .map((e) => e.value).where((element) => !element.video.isBlank!)
                                .toList()
                                .length ==
                            1
                        ? ListView.builder(
                            itemCount: ctx.remoteStreams.entries
                                .map((e) => e.value)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              List<RemoteStream> items = ctx
                                  .remoteStreams.entries
                                  .map((e) => e.value).where((element) => !element.video.isBlank!)
                                  .toList();

                              print('items length -----------> ${items.length}');

                              RemoteStream remoteStream = items.first;

                              print('items length -----------> ${remoteStream.videoRenderer}');

                              print('items length -----------> ${remoteStream.audioRenderer}');

                              return Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    wbrtc.RTCVideoView(
                                        remoteStream.audioRenderer,
                                        filterQuality: FilterQuality.low,
                                        objectFit: RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                        mirror: true),
                                    wbrtc.RTCVideoView(
                                        remoteStream.videoRenderer,
                                        filterQuality: FilterQuality.low,
                                        objectFit: RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                        mirror: true)
                                  ],
                                ),
                              );

                            })
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemCount: ctx.remoteStreams.entries
                                .map((e) => e.value).where((element) => !element.video.isBlank!)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              List<RemoteStream> items = ctx
                                  .remoteStreams.entries
                                  .map((e) => e.value).where((element) => !element.video.isBlank!)
                                  .toList();
                              // print('items length -----------> ${items.length}');
                              RemoteStream remoteStream = items[index];
                              print('---------------- loglog -------------------');
                              print(remoteStream.video.isBlank);
                              // print(
                              //     'items length -----------> ${remoteStream.videoRenderer}');
                              // print(
                              //     'items length -----------> ${remoteStream.audioRenderer}');

                              return Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    wbrtc.RTCVideoView(
                                        remoteStream.audioRenderer,
                                        filterQuality: FilterQuality.low,
                                        objectFit: RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                        mirror: true),
                                    wbrtc.RTCVideoView(
                                        remoteStream.videoRenderer,
                                        filterQuality: FilterQuality.low,
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
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(
        'ویدئو کنفرانس',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.endCallAndExit();
            controller.dispose();
          },
          icon: Icon(Icons.call),
        )
      ],
    );
  }
}
