import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Helper for create common snackbars quickly

class SnackbarHelper {
  static Flushbar successSnackbar(
    String message, {
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    return Flushbar(
      backgroundColor: Colors.grey[900]!,
      icon: const Icon(
        Ionicons.checkmark_circle,
        color: Color(0xff009788),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
    );
  }

  static Flushbar failureSnackbar(
    String title,
    String message, {
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    return Flushbar(
      backgroundColor: Colors.grey[900]!,
      icon: const Icon(Ionicons.warning, color: Color(0xffE06053)),
      title: title,
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      blockBackgroundInteraction: false,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
    );
  }

  static Flushbar infoSnackbar(
    String message, {
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    return Flushbar(
      backgroundColor: Colors.grey[900]!,
      icon: const Icon(
        Ionicons.information_circle,
        color: Color(0xff8EB5F0),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
    );
  }

  static Flushbar notificationSnackbar({
    required String message,
    required IconData icon,
    required String title,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    return Flushbar(
      backgroundColor: Colors.grey[900]!,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      title: title,
      message: message,
      shouldIconPulse: false,
      duration: const Duration(seconds: 5),
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
    );
  }
}
