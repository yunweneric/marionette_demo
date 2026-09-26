import 'package:flutter/foundation.dart';

/// A sign-in that takes a beat and can fail, with no backend behind it.
///
/// The delay matters on stage: the agent has to wait for the spinner and then
/// look again, which is the whole act-then-observe loop.
class FakeAuthService {
  const FakeAuthService();

  static const demoEmail = 'demo@flutter.dev';
  static const demoPassword = 'flutter123';

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('[auth] sign-in attempt for "$email"');
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (email.trim().toLowerCase() != demoEmail) {
      debugPrint('[auth] rejected: unknown account');
      return const AuthResult.failure(
        'We could not find an account for that email.',
      );
    }
    if (password != demoPassword) {
      debugPrint('[auth] rejected: wrong password');
      return const AuthResult.failure('That password is not right.');
    }

    debugPrint('[auth] signed in');
    return const AuthResult.success('Ada');
  }
}

class AuthResult {
  const AuthResult.success(this.displayName) : error = null;
  const AuthResult.failure(this.error) : displayName = null;

  final String? displayName;
  final String? error;

  bool get isSuccess => error == null;
}
