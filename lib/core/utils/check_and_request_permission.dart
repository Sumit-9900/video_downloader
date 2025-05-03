// import 'dart:developer';
import 'dart:io';

import 'package:media_store_plus/media_store_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkAndRequestPermission() async {
  if (Platform.isAndroid) {
    final sdkInt = await MediaStorePlatform.instance.getPlatformSDKInt();

    if (sdkInt >= 33) {
      final videoStatus = await Permission.videos.status;
      if (videoStatus.isGranted) {
        return true;
      }

      final result = await Permission.videos.request();
      return result.isGranted;
    } else {
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result.isGranted;
    }
  }

  return true;
}
