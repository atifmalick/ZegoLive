import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'following_state.dart';

@injectable
class FollowersCubit extends Cubit<FollowersState> {
  final IProfileRepository _repository;

  FollowersCubit(this._repository) : super(FollowersInitialState());

  Future<void> followingUsers(String uid) async {
    emit(FollowersInProgress());

    final result = await _repository.followersUsers(uid);

    result.fold(
      (failure) => emit(FollowersFailure(failure.message)),
      (success) => emit(FollowersSuccess(success)),
    );
  }

  Future<void> removeFolloweUser(String uid) async {
    final result = await _repository.removeFollowerUser(uid);
    result.fold(
      (failure) {
        if (kDebugMode) {
          print("remove followe error");
        }
        emit(FollowersFailure(failure.message));
      },
      (success) {
        if (kDebugMode) {
          print("--- here in success");
        }
        // emit( FollowersSuccess());
        followingUsers(uid);
      },
    );
  }
}
