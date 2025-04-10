import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AppCordinates {
  static double lat = 0.0;
  static double long = 0.0;
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      showToast(context,
          "Location services are disabled. Please enable them in settings.");
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(context,
            "Location permission is denied. Please enable it in settings.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(context,
          "Location permission is permanently denied. Please enable it in settings.");
      return null;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    return position;
  }

  static void showToast(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
