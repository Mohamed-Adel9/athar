import 'package:dio/dio.dart';
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

  Future<AuthModel> currentUser({required String token});

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
      authorize: false,
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

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw const FormatException('Could not create an authentication token.');
    }

    try {
      return await _loginGoogleWithBackend(idToken: idToken, user: user);
    } catch (error) {
      await _firebaseAuth.signOut();
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      rethrow;
    }
  }

  Future<AuthModel> _loginGoogleWithBackend({
    required String idToken,
    required User user,
  }) async {
    final data = {
      'provider': 'google',
      'id_token': idToken,
      'access_token': idToken,
      'token': idToken,
      'firebase_uid': user.uid,
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photo_url': user.photoURL,
      'avatar': user.photoURL,
    };

    for (final endpoint in ApiUrls.googleLoginEndpoints) {
      try {
        final response = await _dioService.post(
          url: endpoint,
          authorize: false,
          data: data,
        );

        return AuthModel.fromResponse(response.data);
      } catch (error) {
        if (!_isMissingRouteError(error)) rethrow;
      }
    }

    throw FormatException(
      'Google login is not configured on the backend. Add a POST /api/${ApiUrls.googleLogin} route that accepts the Firebase ID token and returns an Athar API token.',
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
      authorize: false,
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
  Future<AuthModel> currentUser({required String token}) async {
    final response = await _dioService.get(url: ApiUrls.me);
    return AuthModel.fromSessionResponse(response.data, token: token);
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

bool _isMissingRouteError(Object error) {
  if (error is! DioException) return false;
  if (error.response?.statusCode != 404) return false;

  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message']?.toString().toLowerCase() ?? '';
    return message.contains('route') && message.contains('could not be found');
  }

  return false;
}
