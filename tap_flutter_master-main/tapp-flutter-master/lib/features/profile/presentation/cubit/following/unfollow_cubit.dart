import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'unfollow_state.dart';

@injectable
class UnfollowUserCubit extends Cubit<UnfollowUserState> {
  final IFeedRepository _repository;

  UnfollowUserCubit(this._repository) : super(UnfollowUserInitialState());

  Future<void> unfollowUser(String uid) async {
    emit(UnfollowUserInProgress());

    final result = await _repository.unFollowUser(uid);

    result.fold(
      (failure) => emit(UnfollowUserFailure(failure.message)),
      (success) {
        emit(UnfollowUserSuccess());
      },
    );
  }
}
