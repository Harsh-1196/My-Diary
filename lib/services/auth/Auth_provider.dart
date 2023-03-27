import 'package:mydiary/services/auth/auth_user.dart';

// basically we are doing all this for 2 purpose
// first is to make our code clean and better
// second is to get the power to add other methods to signup like google, fb etc

abstract class Authprovider {
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
