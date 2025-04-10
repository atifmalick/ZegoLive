import 'package:equatable/equatable.dart';

enum NotificationType { chat, helpMe, unknown, newStream }

class TappNotification extends Equatable {
  final String id;
  final String message;
  final String title;
  final int date;
  final NotificationType notificationType;
  final double? latitude;
  final double? longitude;
  final String? alertType;
  final Map<String, dynamic>? extras; // Add the extras field here

  const TappNotification({
    required this.id,
    required this.message,
    required this.title,
    required this.date,
    required this.notificationType,
    this.latitude,
    this.longitude,
    this.alertType,
    this.extras, // Initialize it here
  });

  @override
  List<Object> get props => [
        id,
        message,
        title,
        date,
        notificationType,
      ];
}
