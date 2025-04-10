part of 'delete_post_cubit.dart';

abstract class DeletePostState extends Equatable {
  const DeletePostState();

  @override
  List<Object> get props => [];
}

class DeletePostInitial extends DeletePostState {}

class DeletePostInProgress extends DeletePostState {}

class DeletePostSuccess extends DeletePostState {}

class DeletePostFailure extends DeletePostState {
  final String message;

  const DeletePostFailure(this.message);

  @override
  List<Object> get props => [message];
}
