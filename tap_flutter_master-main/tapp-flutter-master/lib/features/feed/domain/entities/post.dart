import 'package:equatable/equatable.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class Post extends Equatable {
  final String postId;
  final TappUser? creator;
  final String message;
  final Content content;
  final int date;
  final int reportCount;
  final List<Comment> comments;
  final List<dynamic> likes;
  final bool isStream;
  final String recordingUrl;


  const Post({
    required this.postId,
    this.creator,
    required this.message,
    this.reportCount = 0,
    required this.content,
    required this.date,
    required this.comments,
    required this.likes,
    required this.isStream,
    required this.recordingUrl,

  });

  Post copyWith({
    String? postId,
    TappUser? creator,
    String? message,
    Content? content,
    int? date,
    int? reportCount,
    List<Comment>? comments,
    List<dynamic>? likes,
    bool? isStream,
    String? recordingUrl,

  }) {
    return Post(
      postId: postId ?? this.postId,
      creator: creator ?? this.creator,
      message: message ?? this.message,
      reportCount: reportCount ?? this.reportCount,
      content: content ?? this.content,
      date: date ?? this.date,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      isStream: isStream ?? this.isStream,
      recordingUrl: recordingUrl ?? this.recordingUrl,

    );
  }

  @override
  List<Object> get props => [
    postId,
    content,
    message,
    date,
    reportCount,
    likes,
    comments,
    isStream,
    recordingUrl,

  ];
}