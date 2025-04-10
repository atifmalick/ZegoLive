import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required String commentId,
    required String message,
    required String username,
    required String userId,
    required int date,
  }) : super(
          commentId: commentId,
          message: message,
          username: username,
          userId: userId,
          date: date,
        );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      message: json['message'] ?? '',
      username: json['username'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] == null
          ? DateTime.now().millisecondsSinceEpoch
          : DateHelper.dateTimeToTimestamp(
              DateTime.parse(json['date'].toString())),
    );
  }
}

List<CommentModel> commentsFromList(List<dynamic>? list) {
  if (list != null) {
    return list.map((c) => CommentModel.fromJson(c)).toList();
  }

  return [];
}
