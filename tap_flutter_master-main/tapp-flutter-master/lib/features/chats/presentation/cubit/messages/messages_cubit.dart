import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/chats/domain/repositories/chats_repository.dart';

part 'messages_state.dart';

@injectable
class MessagesCubit extends Cubit<MessagesState> {
  final IChatsRepository _repository;
  List<Message> _messages = [];

  MessagesCubit(this._repository) : super(MessagesInitial());

  void getChatMessages(String chatId) async {
    emit(MessagesLoadInProgress());

    final result = await _repository.getChatMessages(chatId);

    result.fold(
      (failure) => emit(MessagesLoadFailure(failure.message)),
      (messages) {
        _messages = messages;
        emit(MessagesLoadSuccess(List.from(messages)));
      },
    );
  }

  void addMessage(Message message) {
    _messages.insert(0, message);
    emit(MessagesLoadSuccess(List.from(_messages)));
  }
}
