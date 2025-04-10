import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String commentId;
  final String message;
  final String username;
  final String userId;
  final int date;

  const Comment({
    required this.commentId,
    required this.message,
    required this.username,
    required this.userId,
    required this.date,
  });

  @override
  List<Object> get props => [commentId, username, userId, date];
}
