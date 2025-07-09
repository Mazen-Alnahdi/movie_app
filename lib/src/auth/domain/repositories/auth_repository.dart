import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  ResultsStream<AuthUser, AuthUser> get authUser;

  ResultFuture<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });
  ResultFuture<AuthUser> signIn({
    required String email,
    required String password,
  });
  ResultVoid signOut();
}
