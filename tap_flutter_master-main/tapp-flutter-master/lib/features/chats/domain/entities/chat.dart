import 'package:equatable/equatable.dart';
import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class Chat extends Equatable {
  final String chatId;
  final int lastMessageDate;
  final Message? lastMessage;
  final TappUser receiver;

  const Chat({
    required this.chatId,
    required this.lastMessageDate,
    this.lastMessage,
    required this.receiver,
  });

  @override
  List<Object> get props => [
        chatId,
        lastMessageDate,
        receiver,
      ];
}
