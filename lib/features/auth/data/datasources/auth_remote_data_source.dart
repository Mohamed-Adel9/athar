import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});

  Future<AuthModel> loginGoogle();

  Future<AuthModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
    this._dioService,
    this._firebaseAuth,
    this._googleSignIn,
  );

  final DioService _dioService;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioService.post(
      url: ApiUrls.login,
      data: {'email': email, 'password': password},
    );
    return AuthModel.fromResponse(response.data);
  }

  @override
  Future<AuthModel> loginGoogle() async {
    late final UserCredential userCredential;

    if (kIsWeb) {
      userCredential = await _firebaseAuth.signInWithPopup(
        GoogleAuthProvider(),
      );
    } else {
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const FormatException(
          'Google Sign-In did not return an ID token.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      userCredential = await _firebaseAuth.signInWithCredential(credential);
    }

    final user = userCredential.user;
    if (user == null) {
      throw const FormatException('Google Sign-In did not return a user.');
    }

    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw const FormatException('Could not create an authentication token.');
    }

    return AuthModel(
      token: token,
      id: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  @override
  Future<AuthModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dioService.post(
      url: ApiUrls.register,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return AuthModel.fromResponse(response.data);
  }

  @override
  Future<void> logout() async {
    Object? apiError;
    StackTrace? apiStackTrace;

    try {
      await _dioService.post(url: ApiUrls.logout);
    } catch (error, stackTrace) {
      apiError = error;
      apiStackTrace = stackTrace;
    } finally {
      await _firebaseAuth.signOut();
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
    }

    if (apiError != null) {
      Error.throwWithStackTrace(apiError, apiStackTrace!);
    }
  }
}
