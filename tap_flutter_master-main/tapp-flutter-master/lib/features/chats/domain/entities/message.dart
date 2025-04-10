import 'package:equatable/equatable.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class Message extends Equatable {
  final String userId;
  final String message;
  final Content content;
  final int date;

  const Message({
    required this.userId,
    required this.message,
    required this.content,
    required this.date,
  });

  Message copyWith({String? message}) {
    return Message(
      userId: userId,
      message: message ?? this.message,
      content: content,
      date: date,
    );
  }

  @override
  List<Object> get props => [userId, message, content, date];
}
