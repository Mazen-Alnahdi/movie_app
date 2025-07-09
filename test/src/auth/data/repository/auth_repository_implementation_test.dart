import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  const authUserModel = AuthUserModel(
    id: '123',
    name: 'test',
    email: 'test@test.com',
  );

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
        ).thenAnswer((_) => Stream.value(authUserModel));

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
}
