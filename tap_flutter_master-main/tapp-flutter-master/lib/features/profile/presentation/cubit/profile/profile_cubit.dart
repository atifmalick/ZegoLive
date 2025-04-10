import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/features/notifications/presentation/cubit/firebase_notifications/firebase_notifications_cubit.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final IProfileRepository _repository;
  final FirebaseNotificationsCubit _firebaseNotificationsCubit;

  ProfileCubit(
    this._repository,
    this._firebaseNotificationsCubit,
  ) : super(ProfileInitial());

  Future<void> getAllUserInfo() async {
    final result = await _repository.getAllUserInfo();

    result.fold(
      (failure) => emit(ProfileLoadFailure()),
      (tappUser) => emit(ProfileLoadSuccess(tappUser)),
    );
  }

  Future<void> updateToken() async {
    try {
      final fcmToken = await _firebaseNotificationsCubit.token;
      await _repository.updateUserInfo({
        'userData': {
          'messagingToken': fcmToken,
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    await _repository.updateUserInfo({
      'userData': {
        'phone': phoneNumber,
      }
    });
  }

  void updateUserLocation(double latitude, double longitude, String uid) async {
    final result = await _repository.updateUserLocation({
      "data": {
        "latitude": latitude,
        "longitude": longitude,
      }
    });
    // final result = await _repository.updateUserLocation({
    //   "latitude": latitude,
    //   "longitude": longitude,
    // });
    result.fold(
      (failure) {},
      (success) => {},
    );
  }

  void replaceUserInfo(TappUser user) {
    emit(ProfileLoadSuccess(user));
  }

  void updateUserState(Map<String, dynamic> userUpdate) {
    TappUser user = TappUser.fromJson(userUpdate);
    emit(ProfileLoadSuccess(user));
  }
}
