import 'package:tapp/features/chats/domain/entities/message.dart';
import 'package:tapp/features/feed/data/models/content_model.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class MessageModel extends Message {
  const MessageModel({
    required String userId,
    required String message,
    required ContentModel content,
    required int date,
  }) : super(userId: userId, message: message, content: content, date: date);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      content: parseMessageContent(json['content']),
      date: json['date'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

MessageModel? lastMessageFromList(List<dynamic>? messages) {
  if (messages != null) {
    final message = messages[0];
    return MessageModel.fromJson(message);
  }

  return null;
}

ContentModel parseMessageContent(List<dynamic>? content) {
  if (content != null && content.isNotEmpty) {
    return ContentModel.fromJson(content.first);
  } else {
    return const ContentModel(url: '', type: ContentType.unknown);
  }
}
