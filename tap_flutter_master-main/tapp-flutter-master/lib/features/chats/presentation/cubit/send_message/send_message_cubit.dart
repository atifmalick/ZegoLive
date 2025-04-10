import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/chats/domain/repositories/chats_repository.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';

part 'send_message_state.dart';

@injectable
class SendMessageCubit extends Cubit<SendMessageState> {
  final IChatsRepository _repository;

  SendMessageCubit(
    this._repository,
  ) : super(SendMessageInitial());

  void sendMessage(Map<String, dynamic> data) async {
    emit(SendMessageInProgress());

    final result = await _repository.sendMessage(data);

    result.fold(
      (failure) => emit(SendMessageFailure(failure.message)),
      (message) => emit(SendMessageSuccess(message)),
    );
  }
}
