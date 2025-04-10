// import 'package:equatable/equatable.dart';
// import 'package:bloc/bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:tapp/features/feed/domain/repositories/i_feed_repository.dart';

// part 'remove_follower_state.dart';

// @injectable
// class RemoveFolloweUserCubit extends Cubit<RemoveFollowerUserState> {
//   final IFeedRepository _repository;

//   RemoveFolloweUserCubit(this._repository)
//       : super(RemoveFollowerUserInitialState());

//   Future<void> removeFolloweUser(String uid) async {
//     emit(RemoveFollowerUserInProgress());

//     final result = await _repository.removeFollowerUser(uid);

//     result.fold(
//       (failure) => emit(RemoveFollowerUserFailure(failure.message)),
//       (success) {
//         print("--- here in success");
//         emit(RemoveFollowerUserSuccess());
//       },
//     );
//   }
// }
