part of 'add_comment_cubit.dart';

abstract class AddCommentState extends Equatable {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

class AddCommentInitial extends AddCommentState {}

class AddCommentInProgress extends AddCommentState {}

class AddCommentSuccess extends AddCommentState {
  final Comment comment;

  const AddCommentSuccess(this.comment);

  @override
  List<Object> get props => [comment];
}

class AddCommentFailure extends AddCommentState {
  final String message;

  const AddCommentFailure(this.message);

  @override
  List<Object> get props => [message];
}
