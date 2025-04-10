part of 'like_dislike_cubit.dart';

abstract class LikeDislikeState extends Equatable {
  const LikeDislikeState();

  @override
  List<Object> get props => [];
}

class LikeDislikeInitial extends LikeDislikeState {}

class LikeDislikeSuccess extends LikeDislikeState {
  final Post post;

  const LikeDislikeSuccess(this.post);

  @override
  List<Object> get props => [post];
}

class LikeDislikeFailure extends LikeDislikeState {
  final String message;

  const LikeDislikeFailure(this.message);

  @override
  List<Object> get props => [message];
}
