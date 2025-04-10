import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tapp/features/notifications/presentation/cubit/firebase_notifications/firebase_notifications_cubit.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _repository;
  final IProfileRepository _profileRepository;
  final FirebaseNotificationsCubit _firebaseNotificationsCubit;
  final SharedPreferences prefs;
  Locale? deviceLocale;

  AuthCubit(this._repository, this._firebaseNotificationsCubit, this.prefs,
      this._profileRepository)
      : super(AuthInitial());

  /// Check if an user is already signed In
  Future<void> checkSignedInUser() async {
    emit(AuthInProgress());
    final result = await _repository.getSignedInUser();
    // signOut();
    await result.fold(
      (failure) {
        emit(Unauthenticated());
        _checkOnboardingStatus();
      },
      (firebaseUser) async {
        await _verifyUserInfo(firebaseUser);
      },
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _repository.signOut();
    await _firebaseNotificationsCubit.deleteToken();
    emit(Unauthenticated());
    _checkOnboardingStatus();
  }

  /// Depending on missing information, redirect the user
  /// using an AuthState and passing namedRoute.
  /// Also, update the user's firebase messaging token
  Future<void> _verifyUserInfo(User firebaseUser) async {
    final tappUser = (await _profileRepository.getAllUserInfo())
        .fold((failure) => null, (user) => user);

    // print(await FirebaseAuth.instance.currentUser?.getIdToken(true));
    // print(tappUser);
    if (tappUser == null) {
      // signOut();
      emit(Unauthenticated());
    } else if (tappUser.phone?.isEmpty != false) {
      emit(MissingInfo(
        firebaseUser,
        redirectTo: Routes.phoneVerificationScreen,
      ));
    } else if (tappUser.name?.isEmpty != false) {
      emit(MissingInfo(
        firebaseUser,
        redirectTo: Routes.updateMissingInfoScreen,
      ));
    } else {
      emit(Authenticated(firebaseUser));
    }
  }

  void _checkOnboardingStatus() {
    final onboardingAlreadyViewed = prefs.getBool('onboarding') ?? false;
    if (!onboardingAlreadyViewed) {
      emit(OnboardingNotViewed());
    }
  }
}
