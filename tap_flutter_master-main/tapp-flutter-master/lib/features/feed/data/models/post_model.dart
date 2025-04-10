import 'package:tapp/features/feed/data/models/comment_model.dart';
import 'package:tapp/features/feed/data/models/content_model.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/profile/data/models/tapp_user_model.dart';

class PostModel extends Post {
  const PostModel({
    required String postId,
    TappUserModel? creator,
    required ContentModel content,
    required String message,
    required int date,
    int reportCount = 0,
    required List<CommentModel> comments,
    required List<dynamic> likes,
    required bool isStream,
    required String recordingUrl,
  }) : super(
    postId: postId,
    creator: creator,
    content: content,
    reportCount: reportCount,
    message: message,
    date: date,
    comments: comments,
    likes: likes,
    isStream: isStream,
    recordingUrl: recordingUrl,
  );

  factory PostModel.fromJson(Map<String, dynamic> json,
      {required Map<String, dynamic> jsonCreator}) {
    return PostModel(
      postId: json['postId'] ?? '',
      creator: TappUserModel.fromJson(jsonCreator),
      content: parsePostContent(json['content']),
      message: json['message'] ?? '',
      reportCount: json['reportCount'] ?? 0,
      date:
      // json['date'] == null
      // ? DateHelper.currentTimestamp()
      // :
      //  json['date'].runtimeType == int
      // ?
      // json[
      //     'date'], //
      //     :
      DateTime.parse(json['date']).microsecondsSinceEpoch,
      comments: commentsFromList(json['comments']),
      likes: json['likes'] ?? [],
      isStream: json['isStream'] ?? false,
      recordingUrl: json['recordingUrl'] ?? '',
    );
  }
}

ContentModel parsePostContent(List<dynamic>? content) {
  if (content != null && content.isNotEmpty) {
    return ContentModel.fromJson(content.first);
  } else {
    return const ContentModel(url: '', type: ContentType.unknown);
  }
}