part of 'send_message_cubit.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageInProgress extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final Message message;

  const SendMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageFailure extends SendMessageState {
  final String message;

  const SendMessageFailure(this.message);

  @override
  List<Object> get props => [message];
}
