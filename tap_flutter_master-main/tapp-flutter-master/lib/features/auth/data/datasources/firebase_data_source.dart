import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';

abstract class IAuthFirebaseDataSource {
  /// Get current user signed In
  Future<User> getSignedInUser();

  /// Firebase SignIn with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Firebase signIn with credentials
  Future<void> signInWithCredential(AuthCredential authCredential);

  /// Firebase phone verification
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  });

  /// Link phone credentials to current user after phone verification
  Future<void> linkCredentials(AuthCredential authCredential);

  /// Validate sms code and return a credential to signIn or link
  AuthCredential validateSmsCode({
    required String verificationId,
    required String code,
  });

  Future<void> resetPassword(String email);

  /// Firebase signOut
  Future<void> signOut();
}

@Injectable(as: IAuthFirebaseDataSource)
class AuthFirebaseDataSource implements IAuthFirebaseDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseDataSource(this._firebaseAuth);

  @override
  Future<User> getSignedInUser() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      return user;
    } else {
      throw FirebaseServerException('Inicia sesión nuevamente por favor.');
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var d = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(d.toString(), name: "token: ");
    } on FirebaseAuthException catch (e) {
      String message = 'Error inesperado.';

      if (e.code == "invalid-email" || e.code == "wrong-password") {
        message = 'Correo o contraseña incorrecta.';
      } else if (e.code == "user-not-found" || e.code == "user-disabled") {
        message = 'Usuario deshabilitado o inexistente.';
      }

      throw FirebaseServerException(message);
    }
  }

  @override
  Future<void> signInWithCredential(AuthCredential authCredential) async {
    try {
      await _firebaseAuth.signOut();
      await _firebaseAuth.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      String message = 'Error inesperado.';

      if (e.code == "invalid-email" || e.code == "wrong-password") {
        message = 'Correo o contraseña incorrecta.';
      } else if (e.code == "user-not-found" || e.code == "user-disabled") {
        message = 'Usuario deshabilitado o inexistente.';
      }

      throw FirebaseServerException(message);
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
    return await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> linkCredentials(AuthCredential authCredential) async {
    final user = _firebaseAuth.currentUser;

    try {
      await user?.linkWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      String message = "Error inesperado";

      if (e.code == 'credential-already-in-use') {
        message = 'El número de teléfono ya está asociado a otra cuenta.';
      } else if (e.code == 'provider-already-linked') {
        message = 'El número de telefono ya está asociado.';
      }

      throw FirebaseServerException(message);
    }
  }

  @override
  AuthCredential validateSmsCode({
    required String verificationId,
    required String code,
  }) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
  }

  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return;
    } catch (e) {
      throw FirebaseServerException(
        'Hubo un error al recuperar la contraseña, verifica el correo introducido.',
      );
    }
  }
}
