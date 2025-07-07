import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/src/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get user;

  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();

  Future<void> createUser({required User user, required String name});
}
