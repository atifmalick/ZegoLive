import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/profile/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

@LazySingleton(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final IProfileGraphqlDataSource _graphqlDataSource;

  ProfileRepository(this._graphqlDataSource);

  @override
  Future<Either<Failure, TappUser>> updateUserInfo(
    Map<String, dynamic> data,
  ) async {
    try {
      final updatedUser = await _graphqlDataSource.updateUserInfo(data);
      return right(updatedUser);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserLocation(
    Map<String, dynamic> data,
  ) async {
    try {
      await _graphqlDataSource.updateUserLocation(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TappUser>> getAllUserInfo() async {
    try {
      final user = await _graphqlDataSource.getAllUserInfo();
      return right(user);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addUserToTrustList(
    Map<String, dynamic> data,
  ) async {
    try {
      await _graphqlDataSource.addUserToTrustList(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TappUser>>> getTrustList(String uid) async {
    try {
      final users = await _graphqlDataSource.getTrustList(uid);
      return right(users);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeUserFromTrustList(
    Map<String, dynamic> data,
  ) async {
    try {
      await _graphqlDataSource.removeUserFromTrustList(data);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TappUser>>> followingUsers(String uid) async {
    try {
      final users = await _graphqlDataSource.followingUsers(uid);
      return right(users);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFollowerUser(String uid) async {
    try {
      await _graphqlDataSource.removeFollowerUser(uid);
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TappUser>>> followersUsers(String uid) async {
    try {
      final users = await _graphqlDataSource.followersUsers(uid);
      return right(users);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }
}
