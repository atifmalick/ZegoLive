import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/entities/comment.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'add_comment_state.dart';

@injectable
class AddCommentCubit extends Cubit<AddCommentState> {
  final IFeedRepository _repository;

  AddCommentCubit(this._repository) : super(AddCommentInitial());

  void addComment(Map<String, dynamic> data) async {
    emit(AddCommentInProgress());

    final result = await _repository.addComment(data);

    result.fold(
      (failure) => emit(AddCommentFailure(failure.message)),
      (comment) => emit(AddCommentSuccess(comment)),
    );
  }
}
