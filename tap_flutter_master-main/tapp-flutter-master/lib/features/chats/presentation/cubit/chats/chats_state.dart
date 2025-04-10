part of 'chats_cubit.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoadInProgress extends ChatsState {}

class ChatsLoadSuccess extends ChatsState {
  final List<Chat> chats;

  const ChatsLoadSuccess(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatsLoadFailure extends ChatsState {
  final String message;

  const ChatsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
