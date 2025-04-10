import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<void> requestLocationPermission({
    required Function ifLocationDisabled,
  }) async {
    Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.location].request();

    var status = await Permission.location.status;

    if (status.isGranted) {
      // Permission Granted;
    } else if (status.isDenied) {
      // denied

    }
    await requestPermissionIfNeeded(
      await Permission.location.status,
      Permission.location,
    );

    final serviceStatus = await Permission.location.serviceStatus.isEnabled;

    if (!serviceStatus) {
      ifLocationDisabled();
    }
  }

  static Future<void> requestCameraPermission() async {
    await requestPermissionIfNeeded(
      await Permission.camera.status,
      Permission.camera,
    );
  }

  static Future<void> requestGalleryPermission() async {
    await requestPermissionIfNeeded(
      await Permission.photos.status,
      Permission.photos,
    );
  }

  static Future<void> requestStoragePermission() async {
    await requestPermissionIfNeeded(
      await Permission.storage.status,
      Permission.storage,
    );
  }

  static Future<void> requestMicrophonePermission() async {
    await requestPermissionIfNeeded(
      await Permission.microphone.status,
      Permission.microphone,
    );
  }

  static Future<void> requestNotificationsPermission() async {
    await requestPermissionIfNeeded(
      await Permission.notification.status,
      Permission.notification,
    );
  }

  static Future<void> requestPermissionIfNeeded(
    PermissionStatus status,
    Permission permission,
  ) async {
    switch (status) {
      case PermissionStatus.denied:
        if (Platform.isIOS) openAppSettings();
        await permission.request();
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
      default:
        break;
    }
  }
}
