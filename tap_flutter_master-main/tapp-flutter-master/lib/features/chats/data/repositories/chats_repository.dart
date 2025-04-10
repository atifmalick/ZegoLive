import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/chats/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/chats/domain/entities/chat.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/chats/domain/repositories/chats_repository.dart';

@LazySingleton(as: IChatsRepository)
class ChatsRepository implements IChatsRepository {
  final IChatsGraphqlDataSource _graphqlDataSource;

  ChatsRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, List<Chat>>> getChats(String uid) async {
    try {
      final chats = await _graphqlDataSource.getChats(uid);
      return right(chats);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final chatMessages = await _graphqlDataSource.getChatMessages(chatId);
      return right(chatMessages);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
    Map<String, dynamic> data,
  ) async {
    try {
      final message = await _graphqlDataSource.sendMessage(data);
      return right(message);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }
}
