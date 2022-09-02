// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:lottie/lottie.dart';
//
// import '../../Controllers/Live/live_controller.dart';
// import '../../Plugins/get/get.dart';
// import '../../Utils/Live/Helper.dart';
// import 'Widgets/subscribers-screen.dart';
//
// class LiveScreen extends StatelessWidget {
//   LiveScreen({Key? key}) : super(key: key);
//
//   final LiveController controller = Get.put(LiveController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppbar(),
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         child: GetBuilder(
//           init: controller,
//           id: 'live',
//           builder: (ctx) => Stack(
//             children: [
//               Container(
//                 height: Get.height,
//                 width: Get.width,
//                 child: Column(
//                   children: [
//                     (controller.remoteStreams.entries
//                             .map((e) => e.value)
//                             .isEmpty)
//                         ? SizedBox()
//                         : Container(
//                             width: Get.width,
//                             height: Get.height * .35,
//                             child: Stack(
//                               children: [
//                                 RTCVideoView(
//                                   controller.myAudioRenderer!,
//                                   filterQuality: FilterQuality.medium,
//                                   objectFit: RTCVideoViewObjectFit
//                                       .RTCVideoViewObjectFitCover,
//                                   mirror: true,
//                                 ),
//                                 RTCVideoView(
//                                   controller.myVideoRenderer!,
//                                   filterQuality: FilterQuality.medium,
//                                   objectFit: RTCVideoViewObjectFit
//                                       .RTCVideoViewObjectFitCover,
//                                   mirror: true,
//                                 )
//                               ],
//                             ),
//                           ),
//                     (controller.remoteStreams.entries
//                                 .map((e) => e.value)
//                                 .toList()
//                                 .length ==
//                             1)
//                         ? SizedBox()
//                         : Expanded(
//                             child: SizedBox(
//                               height: double.maxFinite,
//                               width: double.maxFinite,
//                               child: GridView.builder(
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 3),
//                                 itemCount: controller.remoteStreams.entries
//                                     .map((e) => e.value)
//                                     .toList()
//                                     .getRange(
//                                         1,
//                                         controller.remoteStreams.entries
//                                             .map((e) => e.value)
//                                             .toList()
//                                             .length)
//                                     .length,
//                                 itemBuilder: (context, index) {
//                                   List<RemoteStream> items = controller
//                                       .remoteStreams.entries
//                                       .map((e) => e.value)
//                                       .toList().getRange(1, controller.remoteStreams.entries
//                                       .map((e) => e.value)
//                                       .toList()
//                                       .length).toList();
//                                   RemoteStream remoteStream = items[index];
//                                   return Stack(
//                                     children: [
//                                       RTCVideoView(
//                                         remoteStream.audioRenderer,
//                                         filterQuality: FilterQuality.medium,
//                                         objectFit: RTCVideoViewObjectFit
//                                             .RTCVideoViewObjectFitCover,
//                                         mirror: true,
//                                       ),
//                                       RTCVideoView(
//                                         remoteStream.videoRenderer,
//                                         filterQuality: FilterQuality.medium,
//                                         objectFit: RTCVideoViewObjectFit
//                                             .RTCVideoViewObjectFitCover,
//                                         mirror: true,
//                                       )
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                           )
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 110),
//                   width: MediaQuery.of(context).size.width * 0.65,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       FloatingActionButton(
//                         heroTag: '6',
//                         onPressed: () {},
//                         child: Icon(Icons.add_photo_alternate_outlined),
//                       ),
//                       FloatingActionButton(
//                         heroTag: '9',
//                         onPressed: () {
//                           // controller.showUsers.value = true;
//                           controller.showUsersModal();
//                         },
//                         child: Icon(Icons.person_add),
//                       ),
//                       FloatingActionButton(
//                         heroTag: '5',
//                         onPressed: () {
//                           // controller.showUsers.value = true;
//                           controller.switchCamera();
//                         },
//                         child: Icon(Icons.switch_camera_outlined),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Obx(
//                 () => controller.showUsers.value
//                     ? SubscribersScreen(
//                         controller: controller,
//                         subscripers: controller.subStreams,
//                         callback: () {
//                           controller.showUsers.value = false;
//                         },
//                       )
//                     : Container(),
//               )
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
//         GetBuilder(
//           init: controller,
//           id: 'live',
//           builder: (ctx) => Row(
//             children: [
//               Text(
//                 controller.subscribersList.length.toString(),
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.white60,
//                 ),
//               ),
//               Icon(
//                 Icons.visibility_outlined,
//                 color: Colors.white60,
//                 size: 16.0,
//               )
//             ],
//           ),
//         ),
//         Lottie.asset('assets/animations/liveAlert.json')
//       ],
//     );
//   }
// }
