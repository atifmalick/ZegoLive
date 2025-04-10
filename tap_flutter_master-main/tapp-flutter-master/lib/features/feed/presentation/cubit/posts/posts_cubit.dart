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
  Timer? timer;
  List<Post> _posts = [];
  double radius = 12000;

  PostsCubit(this._repository) : super(PostsInitial());

  /// Get nearby posts every 15 seconds
  Future<void> getPosts(String uid) async {
    timer?.cancel();
    await _getNearbyPosts(uid);
    timer = Timer.periodic(
      const Duration(seconds: 15),
          (Timer t) async {
        await _getNearbyPosts(uid);
      },
    );
  }

  void setRadius(double radius) {
    this.radius = radius;
  }

  /// Add the created post to the postsList
  void addPost(Post post) async {
    emit(PostsLoadInProgress());
    _posts.insert(0, post);
    await Future.delayed(const Duration(milliseconds: 300));
    emit(PostsLoadSuccess(List.from(_posts)));
  }

  void replacePost(Post post) {
    final index = _posts.indexWhere((p) => p.postId == post.postId);
    if (index != -1) {
      _posts.removeAt(index);
      _posts.insert(index, post);
      emit(PostsLoadSuccess(List.from(_posts)));
    } else {
      log("Post ${post.postId} not found, adding as new");
      _posts.insert(0, post);
      emit(PostsLoadSuccess(List.from(_posts)));
    }
  }

  void addComment(Post post, Comment comment) {
    final modifiedPost = post.copyWith();
    modifiedPost.comments.add(comment);
    replacePost(modifiedPost);
  }

  void removePost(Post post) {
    _posts.removeWhere((p) => p.postId == post.postId);
    emit(PostsLoadSuccess(List.from(_posts)));
  }

  /// Update the streaming status of a post
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

  /// Handle stream end event and fetch recordingUrl after 20 seconds
  Future<void> onStreamEnded(String postId, String uid) async {
    final index = _posts.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      final post = _posts[index];
      // Wait 20 seconds before fetching the recording URL
      log("Stream ended for $postId: Waiting 20s to fetch recordingUrl");
      await Future.delayed(const Duration(seconds: 20));

      if (_posts.any((p) => p.postId == postId)) {
        final result = await _repository.getNearbyPosts(uid, radius);
        result.fold(
              (failure) {
            log("Failed to fetch recording URL for $postId after 20s: $failure");
          },
              (posts) {
            final updatedPost = posts.firstWhere(
                  (p) => p.postId == postId,
              orElse: () => _posts[index], // Fallback to current post
            );
            if (updatedPost.recordingUrl != null && updatedPost.recordingUrl!.isNotEmpty) {
              _posts[index] = updatedPost;
              log("Recording URL fetched after 20s for $postId: ${updatedPost.recordingUrl}");
              emit(PostsLoadSuccess(List.from(_posts)));
            } else {
              log("No recording URL available after 20s for $postId");
            }
          },
        );
      } else {
        log("Post $postId no longer exists after 20s delay");
      }
    } else {
      log("Post $postId not found when stream ended");
    }
  }

  Future<void> _getNearbyPosts(String uid) async {
    emit(PostsLoadInProgress());
    final result = await _repository.getNearbyPosts(uid, radius);
    result.fold(
          (failure) {
        log("Failed to fetch nearby posts: $failure");
        emit(PostsLoadFailure());
      },
          (posts) {
        for (final newPost in posts) {
          final existingPostIndex = _posts.indexWhere((p) => p.postId == newPost.postId);
          if (existingPostIndex != -1) {
            final existingPost = _posts[existingPostIndex];
            // Check if recordingUrl is now available
            if (existingPost.isStream &&
                (existingPost.recordingUrl == null || existingPost.recordingUrl!.isEmpty) &&
                newPost.recordingUrl != null &&
                newPost.recordingUrl!.isNotEmpty) {
              log("Recording URL now available for ${newPost.postId}: ${newPost.recordingUrl}");
              _posts[existingPostIndex] = newPost;
            } else {
              _posts[existingPostIndex] = newPost; // Regular update
            }
          } else {
            // New post
            _posts.add(newPost);
            if (newPost.isStream && (newPost.recordingUrl == null || newPost.recordingUrl!.isEmpty)) {
              log("New stream post ${newPost.postId} detected, scheduling recordingUrl fetch");
              onStreamEnded(newPost.postId, uid); // Assume it might end soon
            }
          }
        }
        for (var post in _posts) {
          log("Fetched post ${post.postId}: isStream=${post.isStream}, recordingUrl=${post.recordingUrl}");
        }
        emit(PostsLoadSuccess(List.from(_posts)));
      },
    );
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}