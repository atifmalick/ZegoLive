import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class PostCommentsScreenArgs {
  final String postId;
  final String ownerId;
  final String uid;

  PostCommentsScreenArgs(this.postId, this.ownerId, this.uid);
}

class ChatMessagesScreenArgs {
  final TappUser? receiver;
  final String chatId;
  final bool newChat;

  ChatMessagesScreenArgs({
    this.receiver,
    this.chatId = '',
    this.newChat = false,
  });
}
