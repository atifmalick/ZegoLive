import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'comments_state.dart';

@injectable
class CommentsCubit extends Cubit<CommentsState> {
  final IFeedRepository _repository;
  List<Comment> _comments = [];

  CommentsCubit(this._repository) : super(CommentsInitial());

  Future<void> getComments(String postId, String ownerId) async {
    emit(CommentsLoadInProgress());

    final result = await _repository.getComments(postId, ownerId);

    result.fold(
      (failure) => emit(CommentsLoadFailure(failure.message)),
      (comments) {
        _comments = comments;
        emit(CommentsLoadSuccess(List.from(_comments)));
      },
    );
  }

  void addComment(Comment comment) {
    _comments.add(comment);
    emit(CommentsLoadSuccess(List.from(_comments)));
  }
}
