import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/auth/data/models/auth_user_model.dart';
import 'package:movie_app/src/auth/data/repository/auth_repository_implementation.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositoryImplementation authRepositoryImplementation;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImplementation = AuthRepositoryImplementation(
      authRemoteDataSource: mockAuthRemoteDataSource,
    );
  });

  const tEmail = 'test@test.com';
  const tPassword = "password";
  const tName = 'test';
  const tAuthUserModel = AuthUserModel(
    id: '123',
    name: 'test',
    email: 'test@test.com',
  );

  const tException = ServerException(message: "Unknown Error", statusCode: 500);

  group('authUser', () {
    test(
      'emits AuthUser.empty() when remoteDataSource.user emits null',
      () async {
        when(
          () => mockAuthRemoteDataSource.user,
        ).thenAnswer((_) => Stream.value(null));

        final result = await authRepositoryImplementation.authUser.first;

        expect(result, equals(Left(AuthUser.empty())));
      },
    );

    test(
      "emits Right(AuthUser) when AuthRepositoryImplementation emits valid AuthUserModel",
      () async {
        when(
          () => mockAuthRemoteDataSource.user,
        ).thenAnswer((_) => Stream.value(tAuthUserModel));

        final result = await authRepositoryImplementation.authUser.first;

        expect(result, equals(isA<Right>()));

        //Testing the fold on both ends to make sure it actually works as im debugging
        // result.fold((_) => fail('Expected Right but got left'), (user) {
        //   expect(user, equals(authUserModel.toEntity()));
        // });
        // expect(actual, matcher)
      },
    );
  });

  group('signUp', () {
    test('Should Call the [AuthRemoteDataSource.signUpWithEmailAndPassword] '
        'and returns AuthUser Successfully', () async {
      when(
        () => mockAuthRemoteDataSource.signUpWithEmailAndPassword(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
        //The return is tAuthUserModel as the func returns that in remoteDataSource
      ).thenAnswer((_) async => tAuthUserModel);

      final result = await authRepositoryImplementation.signUp(
        name: tName,
        email: tEmail,
        password: tPassword,
      );
      expect(result, equals(Right(tAuthUserModel.toEntity())));
    });

    test(
      'Should return [ServerFailure] when the call to remote data source is unsuccessful',
      () async {
        when(
          () => mockAuthRemoteDataSource.signUpWithEmailAndPassword(
            name: tName,
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(tException);

        final result = await authRepositoryImplementation.signUp(
          name: tName,
          email: tEmail,
          password: tPassword,
        );

        expect(
          result,
          equals(
            Left(
              ServerFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
      },
    );
  });

  group('signIn', () {
    test('Should call [AuthRemoteRepositoryImplementation.signIn]'
        ' and returns [AuthUser] Successfully', () async {
      when(
        () => mockAuthRemoteDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthUserModel);

      final result = await authRepositoryImplementation.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(result, equals(Right(tAuthUserModel.toEntity())));
    });

    test('Should return [ServerFailure] when the call to remote data source'
        'is unsuccessful', () async {
      when(
        () => mockAuthRemoteDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(tException);

      final result = await authRepositoryImplementation.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(
        result,
        equals(
          Left(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
    });
  });

  group('signOut', () {
    test('Should call [AuthRepositoryImplementation.signOut]'
        ' and returns void successfully', () async {
      when(
        () => mockAuthRemoteDataSource.signOut(),
      ).thenAnswer((_) => Future.value());

      final result = await authRepositoryImplementation.signOut();

      expect(result, isA<Right>());
    });

    test('Should return [ServerFailure] when the call to [AuthRemoteDataSource]'
        ' is unsuccessful', () async {
      // final expectedFailure = ServerFailure.fromException(tException);
      when(() => mockAuthRemoteDataSource.signOut()).thenThrow(tException);

      final result = await authRepositoryImplementation.signOut();

      expect(result, equals(Left(ServerFailure.fromException(tException))));
    });
  });
}
