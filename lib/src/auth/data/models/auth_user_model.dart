import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({required super.id, super.name, required super.email});

  factory AuthUserModel.fromFirebaseAuthUser(firebase_auth.User firebaseUser) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
    );
  }

  AuthUser toEntity() {
    return AuthUser(id: id, name: name, email: email);
  }
}
