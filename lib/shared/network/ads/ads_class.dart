// // ignore_for_file: unnecessary_new
//
// import 'dart:io';
// import 'package:admob_flutter/admob_flutter.dart';
// class AdsManager{
//   static bool _testMode = true;
//
//
//   static String get appIdEx{
//     if(Platform.isAndroid)
//       {
//         return"----------------------------";
//       }else if(Platform.isIOS)
//         {
//           return "---------------------------------";
//         }
//     else{
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//
//   static String get bannerAdUnitId{
//     if(_testMode == true) {
//       return AdmobBanner.testAdUnitId;
//     }
//     else if(Platform.isAndroid)
//       {
//         return "-------------------------------";
//       }
//     else if(Platform.isIOS)
//       {
//         return "-------------------------------";
//       }
//     else{
//       throw new UnsupportedError('Unsupported platform');
//     }
//   }
// }