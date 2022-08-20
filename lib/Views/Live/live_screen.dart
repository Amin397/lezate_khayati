import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as wbrtc;
import 'package:lottie/lottie.dart';

import '../../Controllers/Live/live_controller.dart';
import '../../Plugins/get/get.dart';
import '../../Utils/Live/Helper.dart';
import 'Widgets/subscribers-screen.dart';

class LiveScreen extends StatelessWidget {
  LiveScreen({Key? key}) : super(key: key);

  final LiveController controller = Get.put(LiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            GetBuilder(
              init: controller,
              id: 'live',
              builder: (ctx) => Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: controller.remoteStreams.entries
                                .map((e) => e.value)
                                .toList()
                                .length ==
                            1
                        ? ListView.builder(
                            itemCount: controller.remoteStreams.entries
                                .map((e) => e.value)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              List<RemoteStream> items = controller
                                  .remoteStreams.entries
                                  .map((e) => e.value)
                                  .toList();
                              // print(
                              //     'items length -----------> ${items.length}');
                              RemoteStream remoteStream = items[index];
                              return Container(
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    wbrtc.RTCVideoView(
                                      remoteStream.audioRenderer,
                                      filterQuality: FilterQuality.medium,
                                      objectFit: wbrtc.RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitContain,
                                      mirror: true,
                                    ),
                                    wbrtc.RTCVideoView(
                                      remoteStream.videoRenderer,
                                      filterQuality: FilterQuality.medium,
                                      objectFit: wbrtc.RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitCover,
                                      mirror: true,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        color: Colors.red,
                                        child: Center(
                                          child: AutoSizeText(
                                              controller.subStreams.length.toString()
                                          ),
                                        ),
                                      ),
                                    )
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
                            itemCount: controller.remoteStreams.entries
                                .map((e) => e.value)
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              List<RemoteStream> items = controller
                                  .remoteStreams.entries
                                  .map((e) => e.value)
                                  .toList();
                              // print(
                              //     'items length -----------> ${items.length}');
                              RemoteStream remoteStream = items[index];
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
                                        objectFit: wbrtc.RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                        mirror: true),
                                    wbrtc.RTCVideoView(
                                        remoteStream.videoRenderer,
                                        filterQuality: FilterQuality.low,
                                        objectFit: wbrtc.RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                        mirror: true),

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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 110),
                width: MediaQuery.of(context).size.width * 0.65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      heroTag: '6',
                      onPressed: () {},
                      child: Icon(Icons.add_photo_alternate_outlined),
                    ),
                    FloatingActionButton(
                      heroTag: '9',
                      onPressed: () {
                        // controller.showUsers.value = true;
                        controller.showUsersModal();
                      },
                      child: Icon(Icons.person_add),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controller.showUsers.value
                  ? SubscribersScreen(
                      subscripers: controller.subStreams,
                      callback: () {
                        controller.showUsers.value = false;
                      },
                    )
                  : Container(),
            )
          ],
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
        Lottie.asset('assets/animations/liveAlert.json')
      ],
    );
  }
}
