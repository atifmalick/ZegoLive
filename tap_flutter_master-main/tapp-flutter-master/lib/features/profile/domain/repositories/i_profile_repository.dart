import 'package:dartz/dartz.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

abstract class IProfileRepository {
  /// Update user's info
  Future<Either<Failure, TappUser>> updateUserInfo(Map<String, dynamic> data);

  /// Update user's location
  Future<Either<Failure, Unit>> updateUserLocation(Map<String, dynamic> data);

  /// Get user's info from social standard
  Future<Either<Failure, TappUser>> getAllUserInfo();

  /// Get user's in trust list
  Future<Either<Failure, List<TappUser>>> getTrustList(String uid);

  /// Add user to trust list
  Future<Either<Failure, Unit>> addUserToTrustList(Map<String, dynamic> data);

  /// Remove user from trust list
  Future<Either<Failure, Unit>> removeUserFromTrustList(
    Map<String, dynamic> data,
  );

  // List following users
  Future<Either<Failure, List<TappUser>>> followingUsers(String uid);

  // List followers users
  Future<Either<Failure, List<TappUser>>> followersUsers(String uid);
  Future<Either<Failure, Unit>> removeFollowerUser(String userId);
}
