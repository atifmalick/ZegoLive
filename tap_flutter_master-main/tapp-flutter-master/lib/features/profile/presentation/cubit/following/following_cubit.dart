import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'following_state.dart';

@injectable
class FollowingCubit extends Cubit<FollowingState> {
  final IProfileRepository _repository;

  FollowingCubit(this._repository) : super(FollowingInitialState());

  Future<void> followingUsers(String uid) async {
    emit(FollowingInProgress());

    final result = await _repository.followingUsers(uid);

    result.fold(
      (failure) => emit(FollowingFailure(failure.message)),
      (success) => emit(FollowingSuccess(success)),
    );
  }
}
