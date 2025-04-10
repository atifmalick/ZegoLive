import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/chats/domain/entities/chat.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';

abstract class IChatsRepository {
  Future<Either<Failure, Message>> sendMessage(
    Map<String, dynamic> data,
  );

  Future<Either<Failure, List<Chat>>> getChats(String uid);
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
}
