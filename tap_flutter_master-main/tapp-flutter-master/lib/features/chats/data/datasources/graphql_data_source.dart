import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/features/chats/data/models/chat_model.dart';
import 'package:tapp/features/chats/data/models/message_model.dart';

abstract class IChatsGraphqlDataSource {
  Future<List<ChatModel>> getChats(String uid);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage(Map<String, dynamic> data);
}

@Injectable(as: IChatsGraphqlDataSource)
class ChatsGraphqlDataSource implements IChatsGraphqlDataSource {
  final GraphQLClient _graphQLClient;

  ChatsGraphqlDataSource(this._graphQLClient);

  @override
  Future<List<ChatModel>> getChats(String uid) async {
    const query = """
      query(\$userId: ID!) {
        chats(userId: \$userId) {
          chatId
          lastMessageDate
          me {
            uid
            name
            lastName
            username
            phone
            profilePicture {
              url
            }
          }
          messages(paginate:{take:1,skip:0}) {
            messageId
            message
            content {
              url
            }
            date
            userId
          }
        }
      }
    """;

    final options = QueryOptions(
      document: gql(query),
      variables: {'userId': uid},
    );

    final response = await _graphQLClient.query(options);

    if (!response.hasException) {
      final List<dynamic> list = response.data!['chats'];
      final chats = list.map((c) => ChatModel.fromJson(c, uid)).toList();

      chats.sort((a, b) => b.lastMessageDate.compareTo(a.lastMessageDate));

      return chats;
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al obtener los chats, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    const query = """
      query(\$chatId: ID!) {
        chatMessages(chatId: \$chatId) {
          message
          userId
          messageId
          date
          content {
            url
          }
        }
      }
    """;

    final options = QueryOptions(
      document: gql(query),
      variables: {'chatId': chatId},
    );

    final response = await _graphQLClient.query(options);

    if (!response.hasException) {
      final List<dynamic> list = response.data!['chatMessages'];
      return list.map((m) => MessageModel.fromJson(m)).toList();
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al obtener los mensajes, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<MessageModel> sendMessage(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: ChatMessageInput!) {
        sendChatMessage(data: \$data) {
            messageId
            userId
            message
            date
            content {
              url
            }
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      variables: data,
    );

    final response = await _graphQLClient.mutate(options);

    if (!response.hasException) {
      final List<dynamic> list = response.data!['sendChatMessage']['messages'];
      return MessageModel.fromJson(list[0]);
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al mandar el mensaje, inténtalo más tarde.',
      );
    }
  }
}
