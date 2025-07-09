import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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

  Future<void> createUser({
    required firebase_auth.User user,
    required String name,
  });
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  AuthRemoteDataSourceImplementation({
    firebase_auth.FirebaseAuth? firebaseAuth,
    required FirebaseFirestore fireStore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _fireStore = fireStore;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;

  @override
  Future<void> createUser({
    required firebase_auth.User user,
    required String name,
  }) async {
    try {
      DocumentReference userDocRef = _fireStore
          .collection('users')
          .doc(user.uid);
      await userDocRef.set({'email': user.email, 'name': name});
    } catch (error) {
      throw Exception("Create User Failed: $error");
    }
  }

  @override
  Stream<AuthUserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) {
        throw Exception('Sign Up Failed: The User is Null after signing up');
      }

      await createUser(user: credential.user!, name: name);

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign Up Failed: $error');
    }
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) {
        throw Exception('Sign In Failed: The User is null after signing in');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign In Failed: $error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw Exception('Sign Out Failed: $error');
    }
  }
}
