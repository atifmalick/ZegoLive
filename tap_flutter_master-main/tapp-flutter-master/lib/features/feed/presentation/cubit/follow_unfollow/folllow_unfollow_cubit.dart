import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

part 'follow_unfollow_state.dart';

@injectable
class FollowUnfollowCubit extends Cubit<FollowUnfollowState> {
  final IFeedRepository repository;

  FollowUnfollowCubit(this.repository) : super(FollowUnfollowInitial());

  void followUSer(String userId) async {
    final result = await repository.followUser(userId);

    result.fold(
      (failure) => emit(FollowUnfollowFailure(failure.message)),
      (success) => emit(FollowUnfollowSuccess()),
    );
  }
}