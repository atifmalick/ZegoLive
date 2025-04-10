part of 'firebase_notifications_cubit.dart';

abstract class FirebaseNotificationsState extends Equatable {
  const FirebaseNotificationsState();

  @override
  List<Object> get props => [];
}

class FirebaseNotificationsInitial extends FirebaseNotificationsState {}

class FirebaseHelpMeNotificationReceived extends FirebaseNotificationsState {
  final FirebaseNotification notification;

  const FirebaseHelpMeNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}

class FirebaseChatNotificationReceived extends FirebaseNotificationsState {
  final FirebaseNotification notification;

  const FirebaseChatNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}

class FirebaseNewStreamNotificationReceived extends FirebaseNotificationsState {
  final FirebaseNotification notification;

  const FirebaseNewStreamNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}
