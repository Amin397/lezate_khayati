// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:lezate_khayati/Plugins/get/get.dart';
//
// import '../../Controllers/JoinLive/join_live_controller.dart';
// import '../../Utils/Live/Helper.dart';
//
// class JoinLiveScreen extends StatelessWidget {
//   JoinLiveScreen({Key? key}) : super(key: key);
//
//   final JoinLiveController controller = Get.put(JoinLiveController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppbar(),
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         child: GetBuilder(
//           id: 'joinLive',
//           builder: (ctx) => Column(
//             children: [
//               Flexible(
//                   flex: 1,
//                   child: controller.remoteStreams.entries
//                               .map((e) => e.value)
//                               .toList()
//                               .length ==
//                           1
//                       ? ListView.builder(
//                           itemCount: controller.remoteStreams.entries
//                               .map((e) => e.value)
//                               .toList()
//                               .length,
//                           itemBuilder: (context, index) {
//                             List<RemoteStream> items = controller
//                                 .remoteStreams.entries
//                                 .map((e) => e.value)
//                                 .toList();
//                             print('items length -----------> ${items.length}');
//                             RemoteStream remoteStream = items[index];
//                             print(
//                                 'items length -----------> ${remoteStream.videoRenderer}');
//                             print(
//                                 'items length -----------> ${remoteStream.audioRenderer}');
//
//                             return Container(
//                               color: Colors.black,
//                               width: MediaQuery.of(context).size.width,
//                               height: MediaQuery.of(context).size.height,
//                               child: Stack(
//                                 children: [
//                                   RTCVideoView(remoteStream.audioRenderer,
//                                       filterQuality: FilterQuality.high,
//                                       objectFit: RTCVideoViewObjectFit
//                                           .RTCVideoViewObjectFitCover,
//                                       mirror: true),
//                                   RTCVideoView(remoteStream.videoRenderer,
//                                       filterQuality: FilterQuality.high,
//                                       objectFit: RTCVideoViewObjectFit
//                                           .RTCVideoViewObjectFitCover,
//                                       mirror: true)
//                                 ],
//                               ),
//                             );
//                           })
//                       : GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 5,
//                             crossAxisSpacing: 5,
//                           ),
//                           itemCount: controller.remoteStreams.entries
//                               .map((e) => e.value)
//                               .toList()
//                               .length,
//                           itemBuilder: (context, index) {
//                             List<RemoteStream> items = controller
//                                 .remoteStreams.entries
//                                 .map((e) => e.value)
//                                 .toList();
//                             print('items length -----------> ${items.length}');
//                             RemoteStream remoteStream = items[index];
//                             print(
//                                 'items length -----------> ${remoteStream.videoRenderer}');
//                             print(
//                                 'items length -----------> ${remoteStream.audioRenderer}');
//
//                             return Container(
//                               color: Colors.black,
//                               width: MediaQuery.of(context).size.width,
//                               height: MediaQuery.of(context).size.height,
//                               child: Stack(
//                                 children: [
//                                   RTCVideoView(remoteStream.audioRenderer,
//                                       filterQuality: FilterQuality.high,
//                                       objectFit: RTCVideoViewObjectFit
//                                           .RTCVideoViewObjectFitCover,
//                                       mirror: true),
//                                   RTCVideoView(remoteStream.videoRenderer,
//                                       filterQuality: FilterQuality.high,
//                                       objectFit: RTCVideoViewObjectFit
//                                           .RTCVideoViewObjectFitCover,
//                                       mirror: true)
//                                 ],
//                               ),
//                             );
//                           })),
//               //here you shoud show image.network
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   AppBar _buildAppbar() {
//     return AppBar(
//       backgroundColor: Colors.red,
//       centerTitle: true,
//       title: Text(
//         'ویدئو کنفرانس',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16.0,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             controller.endCallAndExit();
//             controller.dispose();
//           },
//           icon: Icon(Icons.call),
//         )
//       ],
//     );
//   }
// }
