import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tapp/features/notifications/domain/entities/firebase_notification.dart';

class FirebaseNotificationModel extends FirebaseNotification {
  const FirebaseNotificationModel({
    required NotificationType notificationType,
    String? title,
    String? body,
    String? alertType,
    double? latitude,
    double? longitude,
    String? phone,
  }) : super(
          notificationType: notificationType,
          title: title,
          body: body,
          alertType: alertType,
          latitude: latitude,
          longitude: longitude,
          phone: phone,
        );

  factory FirebaseNotificationModel.fromRemoteMessage(RemoteMessage message) {
    log(message.data.toString(), name: "notification Data");
    log(message.data["streamingId"], name: "StreamingId");
    return FirebaseNotificationModel(
      notificationType:
          parseStringNotificationType(message.data['notificationType']),
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? 'Archivo',
      alertType: message.data['alertType'] ?? '',
      latitude:
          message.data['lat'] != null ? double.parse(message.data['lat']) : 0.0,
      longitude:
          message.data['lng'] != null ? double.parse(message.data['lng']) : 0.0,
      phone: message.data['phone'] ?? '',
    );
  }

  factory FirebaseNotificationModel.fromJson(Map<String, dynamic> json) {
    return FirebaseNotificationModel(
      notificationType: parseStringNotificationType(json['notificationType']),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      alertType: json['alertType'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationType': parseNotificationType(notificationType),
      'title': title,
      'body': body,
      'alertType': alertType,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
    };
  }
}

NotificationType parseStringNotificationType(String notificationType) {
  switch (notificationType) {
    case "HELP_ME_NOTIFICATION":
      return NotificationType.helpMe;
    case "CHAT_MESSAGE_NOTIFICATION":
      return NotificationType.chat;
    case "NEW_STREAM":
      return NotificationType.newStream;
    default:
      return NotificationType.unknown;
  }
}

String parseNotificationType(NotificationType notificationType) {
  switch (notificationType) {
    case NotificationType.helpMe:
      return "HELP_ME_NOTIFICATION";
    case NotificationType.chat:
      return "CHAT_MESSAGE_NOTIFICATION";
    case NotificationType.newStream:
      return "NEW_STREAM";
    default:
      return "UNKNOWN_NOTIFICATION";
  }
}
