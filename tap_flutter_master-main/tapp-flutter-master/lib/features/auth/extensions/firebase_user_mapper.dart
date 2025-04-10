import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

/// Extension to get all user info
extension FirebaseUserMapper on firebase.User {
  Future<TappUser?> getAllInfo() async {
    final repository = getIt<IProfileRepository>();

    final result = await repository.getAllUserInfo();

    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }
}
