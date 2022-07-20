// import 'dart:async';
//
// import 'package:location/location.dart';
// import 'package:lezate_khayati/Utils/view_utils.dart';
//
// class LocationUtils {
//   static Future getLocation() async {
//     Location location = Location();
//
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData _locationData;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     try {
//       _locationData =
//           await location.getLocation().timeout(Duration(seconds: 3));
//     } on TimeoutException catch (e) {
//       ViewUtils.showErrorDialog("لطفا سرویس لوکیشن را فعال کنید");
//       return null;
//     }
//     return _locationData;
//   }
// }
