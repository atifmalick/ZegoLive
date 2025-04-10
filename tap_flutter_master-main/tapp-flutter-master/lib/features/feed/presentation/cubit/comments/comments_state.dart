part of 'comments_cubit.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoadInProgress extends CommentsState {}

class CommentsLoadSuccess extends CommentsState {
  final List<Comment> comments;

  const CommentsLoadSuccess(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentsLoadFailure extends CommentsState {
  final String message;

  const CommentsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
