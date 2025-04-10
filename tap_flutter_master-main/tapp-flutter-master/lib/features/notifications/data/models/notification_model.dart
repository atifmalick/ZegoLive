import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/notifications/domain/entities/notification.dart';

class TappNotificationModel extends TappNotification {
  const TappNotificationModel({
    required String id,
    required String message,
    required String title,
    required NotificationType notificationType,
    required int date,
    double? latitude,
    double? longitude,
    String? phone,
    String? alertType,
  }) : super(
          id: id,
          message: message,
          title: title,
          date: date,
          latitude: latitude,
          longitude: longitude,
          notificationType: notificationType,
          alertType: alertType,
        );

  factory TappNotificationModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return TappNotificationModel(
      id: json['id'] ?? '',
      message: json['msg'] ?? '',
      title: json['title'] ?? '',
      date: parseDateStr(json['date'] ?? DateHelper.currentTimestamp()),
      latitude: parseLatLng(json['extras'], 'lat'),
      longitude: parseLatLng(json['extras'], 'lng'),
      alertType: json['extras'] != null ? json['extras']['alertType'] : '',
      notificationType: parseNotificationType(json['notificationType']),
    );
  }
}

int parseDateStr(var inputStr) {
  int timestamp = DateHelper.currentTimestamp();
  if (inputStr is int) {
    return timestamp;
  } else {
    DateTime dateTime = DateTime.parse(inputStr);
    timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    return timestamp;
  }
}

double parseLatLng(Map<String, dynamic>? extras, String latLng) {
  if (extras != null) {
    final latitudeOrLongitude = extras[latLng];
    return latitudeOrLongitude ?? 0.0;
  }
  return 0.0;
}

NotificationType parseNotificationType(String notificationType) {
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
