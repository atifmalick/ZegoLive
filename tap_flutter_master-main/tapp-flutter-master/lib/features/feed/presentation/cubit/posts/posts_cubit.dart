import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'posts_state.dart';

@injectable
class PostsCubit extends Cubit<PostsState> {
  final IFeedRepository _repository;
  Timer? _timer;
  List<Post> _posts = [];
  double radius = 12000;

  PostsCubit(this._repository) : super(PostsInitial());



  /// Start fetching nearby posts every 15 seconds
  Future<void> startFetchingPosts(String uid) async {
    _timer?.cancel();
    await _getNearbyPosts(uid);
    _timer = Timer.periodic(
      const Duration(seconds: 15),
          (Timer t) async {
        await _getNearbyPosts(uid);
      },
    );
  }

  Future<void> getPosts(String uid) async {
    _timer?.cancel();
    await _getNearbyPosts(uid);
    _timer = Timer.periodic(
      const Duration(seconds: 15),
          (Timer t) async {
        await _getNearbyPosts(uid);
      },
    );
  }

  void setRadius(double radius) {
    this.radius = radius;
  }

  /// Add a new post to the list
  Future<void> addPost(Post post) async {
    emit(PostsLoadInProgress());
    _posts.insert(0, post);
    await Future.delayed(const Duration(milliseconds: 300));
    emit(PostsLoadSuccess(List.from(_posts)));
  }

  /// Replace an existing post
  void replacePost(Post post) {
    final index = _posts.indexWhere((p) => p.postId == post.postId);
    if (index != -1) {
      _posts[index] = post;
      emit(PostsLoadSuccess(List.from(_posts)));
    } else {
      log("Post ${post.postId} not found, adding as new");
      _posts.insert(0, post);
      emit(PostsLoadSuccess(List.from(_posts)));
    }
  }

  void addComment(Post post, Comment comment) {
    final modifiedPost = post.copyWith(comments: List.from(post.comments)..add(comment));
    replacePost(modifiedPost);
  }

  void removePost(Post post) {
    _posts.removeWhere((p) => p.postId == post.postId);
    emit(PostsLoadSuccess(List.from(_posts)));
  }

  /// Update streaming status
  void updateStreamingStatus(String postId, bool isStreamingActive) {
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      final post = _posts[index];
      final updatedPost = post.copyWith(
        isStream: isStreamingActive,
        recordingUrl: isStreamingActive ? "" : post.recordingUrl,
      );
      _posts[index] = updatedPost;
      log("Updated streaming status for $postId: isStream=$isStreamingActive, recordingUrl=${updatedPost.recordingUrl}");
      emit(PostsLoadSuccess(List.from(_posts)));
    } else {
      log("Post $postId not found for status update");
    }
  }

  /// Handle stream end and fetch recording URL after 15 seconds
  Future<void> onStreamEnded(String postId, String uid) async {
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      log("Stream ended for $postId: Waiting 15s to fetch recordingUrl");
      await Future.delayed(const Duration(seconds: 15));

      if (_posts.any((p) => p.postId == postId)) {
        final result = await _repository.getNearbyPosts(uid, radius);
        result.fold(
              (failure) {
            log("Failed to fetch recording URL for $postId after 15s: $failure");
          },
              (posts) {
            final updatedPost = posts.firstWhere(
                  (p) => p.postId == postId,
              orElse: () => _posts[index],
            );
            if (updatedPost.recordingUrl != null && updatedPost.recordingUrl!.isNotEmpty) {
              _posts[index] = updatedPost.copyWith(isStream: false); // Ensure isStream is false after recording
              log("Recording URL fetched after 15s for $postId: ${updatedPost.recordingUrl}");
              emit(PostsLoadSuccess(List.from(_posts)));
            } else {
              log("No recording URL available after 15s for $postId");
            }
          },
        );
      } else {
        log("Post $postId no longer exists after 15s delay");
      }
    } else {
      log("Post $postId not found when stream ended");
    }
  }

  Future<void> _getNearbyPosts(String uid) async {
    final result = await _repository.getNearbyPosts(uid, radius);
    result.fold(
          (failure) {
        log("Failed to fetch nearby posts: $failure");
        emit(PostsLoadFailure());
      },
          (posts) {
        bool hasChanges = false;
        for (final newPost in posts) {
          final index = _posts.indexWhere((p) => p.postId == newPost.postId);
          if (index != -1) {
            if (_posts[index] != newPost) {
              _posts[index] = newPost;
              hasChanges = true;
            }
          } else {
            _posts.add(newPost);
            hasChanges = true;
          }
        }
        if (hasChanges) {
          emit(PostsLoadSuccess(List.from(_posts)));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}