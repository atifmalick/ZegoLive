// ignore_for_file: avoid_print

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/core/errors/failures.dart';
import 'package:tapp/features/auth/data/datasources/firebase_data_source.dart';
import 'package:tapp/features/auth/data/datasources/graphql_data_source.dart';
import 'package:tapp/features/auth/domain/repositories/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final IAuthFirebaseDataSource _firebaseDataSource;
  final IAuthGraphqlDataSource _graphqlDataSource;

  AuthRepository(this._firebaseDataSource, this._graphqlDataSource);

  @override
  Future<Either<Failure, User>> getSignedInUser() async {
    try {
      final user = await _firebaseDataSource.getSignedInUser();
      return right(user);
    } on FirebaseServerException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on FirebaseServerException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _graphqlDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on GraphqlServerException catch (e) {
      return left(GraphqlFailure(e.message));
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationFailed verificationFailed,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    return _firebaseDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  AuthCredential validateSmsCode({
    required String verificationId,
    required String code,
  }) {
    return _firebaseDataSource.validateSmsCode(
      verificationId: verificationId,
      code: code,
    );
  }

  @override
  Future<Either<Failure, Unit>> linkCredentials(
      AuthCredential authCredential) async {
    try {
      await _firebaseDataSource.linkCredentials(authCredential);
      return right(unit);
    } on FirebaseServerException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<void> signOut() async {
    return await _firebaseDataSource.signOut();
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _firebaseDataSource.resetPassword(email);
      return right(unit);
    } on FirebaseServerException catch (e) {
      return left(FirebaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await _graphqlDataSource.deleteAccount();
      if (kDebugMode) {
        print("deleteAccount completed");
      }
      return right(unit);
    } on GraphqlServerException catch (e) {
      if (kDebugMode) {
        print("Ocurrio un error en deleteAccount------------");
      }
      return left(GraphqlFailure(e.message));
    } on FirebaseServerException catch (e) {
      return left(FirebaseFailure(e.message));
    } on Exception catch (e) {
      return left(GraphqlFailure(e.toString()));
    }
  }
}
