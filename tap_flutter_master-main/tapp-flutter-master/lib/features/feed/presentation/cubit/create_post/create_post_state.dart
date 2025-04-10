part of 'create_post_cubit.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostInProgress extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {
  final Post post;

  const CreatePostSuccess(this.post);

  @override
  List<Object> get props => [post];
}

class CreatePostFailure extends CreatePostState {
  final String message;

  const CreatePostFailure(this.message);

  @override
  List<Object> get props => [message];
}
