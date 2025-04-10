import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/chats/data/models/message_model.dart';
import 'package:tapp/features/chats/domain/entities/chat.dart';
import 'package:tapp/features/profile/data/models/tapp_user_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required String chatId,
    required int lastMessageDate,
    MessageModel? lastMessage,
    required TappUserModel receiver,
  }) : super(
          chatId: chatId,
          lastMessageDate: lastMessageDate,
          lastMessage: lastMessage,
          receiver: receiver,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json, String uid) {
    return ChatModel(
      chatId: json['chatId'] ?? '',
      lastMessageDate: json['lastMessageDate'] ?? DateHelper.currentTimestamp(),
      lastMessage: lastMessageFromList(json['messages']),
      receiver: getReceiverFromBetween(json['between'], uid),
    );
  }
}

TappUserModel getReceiverFromBetween(List<dynamic> between, String uid) {
  final receiver = between.singleWhere(
    (user) => user['uid'] != uid,
    orElse: () => null,
  );

  if (receiver != null) {
    return TappUserModel.fromJson(receiver);
  }

  return TappUserModel(uid: '', username: 'desconocido');
}
