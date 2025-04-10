part of 'send_help_me_alert_cubit.dart';

abstract class SendHelpMeAlertState extends Equatable {
  const SendHelpMeAlertState();

  @override
  List<Object> get props => [];
}

class SendHelpMeAlertInitial extends SendHelpMeAlertState {}

class SendHelpMeAlertInProgress extends SendHelpMeAlertState {}

class SendHelpMeAlertSuccess extends SendHelpMeAlertState {}

class SendHelpMeAlertFailure extends SendHelpMeAlertState {
  final String message;

  const SendHelpMeAlertFailure(this.message);

  @override
  List<Object> get props => [message];
}
