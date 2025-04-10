import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tapp/core/errors/failures.dart';

abstract class IAuthRepository {
  /// Get current firebasUser signed In
  Future<Either<Failure, User>> getSignedInUser();

  /// Sign in the user with an email and password
  Future<Either<Failure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up a new user with an email and password
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Verify user's phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  });

  /// Validate SMS code sent to verify user's phone number
  AuthCredential validateSmsCode({
    required String verificationId,
    required String code,
  });

  /// Link phone auth credential with current user
  Future<Either<Failure, Unit>> linkCredentials(AuthCredential authCredential);

  /// Link phone auth credential with current user
  Future<Either<Failure, Unit>> resetPassword(String email);

  /// Delete the user account
  Future<Either<Failure, Unit>> deleteAccount();

  /// Sign out current user
  Future<void> signOut();
}
