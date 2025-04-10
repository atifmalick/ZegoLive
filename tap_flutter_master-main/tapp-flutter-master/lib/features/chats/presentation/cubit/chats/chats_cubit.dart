import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/chats/domain/entities/chat.dart';
import 'package:tapp/features/chats/domain/repositories/chats_repository.dart';

part 'chats_state.dart';

@lazySingleton
class ChatsCubit extends Cubit<ChatsState> {
  final IChatsRepository _repository;

  ChatsCubit(this._repository) : super(ChatsInitial());

  Future<void> getChats(String uid) async {
    emit(ChatsLoadInProgress());

    final result = await _repository.getChats(uid);

    result.fold(
      (failure) => emit(ChatsLoadFailure(failure.message)),
      (chats) => emit(ChatsLoadSuccess(chats)),
    );
  }
}
