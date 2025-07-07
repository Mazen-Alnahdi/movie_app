import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImplementation({required this.authRemoteDataSource});

  @override
  ResultStream<AuthUser> get authUser {
    return authRemoteDataSource.user.map((authUserModel) {
      if (authUserModel == null) {
        return Left(CacheFailure(message: 'No user found', statusCode: 404));
      }
      return Right(authUserModel.toEntity());
    });
  }

  @override
  ResultFuture<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(authModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultVoid signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return Right(authModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
