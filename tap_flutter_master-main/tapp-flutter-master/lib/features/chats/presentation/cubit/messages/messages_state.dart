part of 'messages_cubit.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoadInProgress extends MessagesState {}

class MessagesLoadSuccess extends MessagesState {
  final List<Message> messages;

  const MessagesLoadSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesLoadFailure extends MessagesState {
  final String message;

  const MessagesLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
