part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoadInProgress extends NotificationsState {}

class NotificationsLoadSuccess extends NotificationsState {
  final List<TappNotification> notifications;

  const NotificationsLoadSuccess(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsLoadFailure extends NotificationsState {
  final String message;

  const NotificationsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
