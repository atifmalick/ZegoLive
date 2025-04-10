import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

part 'update_profile_state.dart';

@injectable
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final IProfileRepository _repository;

  UpdateProfileCubit(this._repository) : super(UpdateProfileInitial());

  Future<void> updateProfileInfo(Map<String, dynamic> data) async {
    emit(UpdateProfileInProgress());

    final result = await _repository.updateUserInfo(data);

    result.fold(
      (failure) {
        emit(UpdateProfileFailure(failure.message));
      },
      (user) {
        emit(UpdateProfileSuccess(user));
      },
    );
  }
}
