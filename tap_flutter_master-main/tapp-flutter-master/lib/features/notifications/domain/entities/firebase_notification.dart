import 'package:equatable/equatable.dart';

enum NotificationType { chat, helpMe, unknown, newStream }

class FirebaseNotification extends Equatable {
  final NotificationType notificationType;
  final String? title;
  final String? body;
  final String? alertType;
  final double? latitude;
  final double? longitude;
  final String? phone;

  const FirebaseNotification({
    required this.notificationType,
    this.title,
    this.body,
    this.alertType,
    this.latitude,
    this.longitude,
    this.phone,
  });

  @override
  List<Object> get props => [notificationType];
}
