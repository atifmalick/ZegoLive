import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

part 'create_post_state.dart';

@injectable
class CreatePostCubit extends Cubit<CreatePostState> {
  final IFeedRepository _repository;

  CreatePostCubit(this._repository) : super(CreatePostInitial());

  Future<void> createPost(Map<String, dynamic> data, TappUser creator) async {
    emit(CreatePostInProgress());

    final result = await _repository.createPost(data, creator);

    result.fold(
      (failure) => emit(CreatePostFailure(failure.message)),
      (post) => emit(CreatePostSuccess(post)),
    );
  }
}
