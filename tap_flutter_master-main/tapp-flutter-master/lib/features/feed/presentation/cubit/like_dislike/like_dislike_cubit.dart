import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'like_dislike_state.dart';

@injectable
class LikeDislikeCubit extends Cubit<LikeDislikeState> {
  final IFeedRepository _repository;

  LikeDislikeCubit(this._repository) : super(LikeDislikeInitial());

  void likeUnlikePost(Post post, String uid) async {
    final result = await _repository.toggleLike({
      'userId': uid,
      'postId': post.postId,
    });

    result.fold(
      (failure) => emit(LikeDislikeFailure(failure.message)),
      (_) {
        final alreadyLiked = post.likes.contains(uid);
        final likes = List.from(post.likes);

        alreadyLiked ? likes.remove(uid) : likes.add(uid);

        emit(LikeDislikeSuccess(post.copyWith(likes: likes)));
      },
    );
  }
}
