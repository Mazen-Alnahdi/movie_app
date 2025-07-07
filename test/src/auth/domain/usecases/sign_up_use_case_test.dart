import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_up_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpUseCase signUpUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
  });

  final String tEmail = 'test@test.com';
  final String tName = 'test test';
  final String tPassword = 'password';
  final tAuthUser = AuthUser(id: '123', email: tEmail, name: tName);
  final tSignUpParams = SignUpParams(
    name: tName,
    email: tEmail,
    password: tPassword,
  );

  test(
    "Should call signUp on the AuthRepository and return AuthUser",
    () async {
      // Arrange
      when(
        () => mockAuthRepository.signUp(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => Right(tAuthUser));

      // Act
      final result = await signUpUseCase(tSignUpParams);

      // Assert
      expect(result, Right(tAuthUser));
      verify(
        () => mockAuthRepository.signUp(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'Should throw Exception when signup method on the AuthRepository throws an Exception',
    () async {
      when(
        () => mockAuthRepository.signUp(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(Exception());

      expect(
        () async => await signUpUseCase.call(tSignUpParams),
        throwsA(isA<Exception>()),
      );
    },
  );
}
