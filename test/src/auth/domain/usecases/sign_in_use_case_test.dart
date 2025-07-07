import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_in_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInUseCase signInUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(authRepository: mockAuthRepository);
  });

  final String tEmail = 'test@test.com';
  final String tPassword = 'password';
  final tAuthUser = AuthUser(id: '123', email: tEmail);
  final tSignInParams = SignInParams(email: tEmail, password: tPassword);

  test(
    "Should call signIn on the AuthRepository and return AuthUser",
    () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => Right(tAuthUser));

      // Act
      final result = await signInUseCase(tSignInParams);

      // Assert
      expect(result, Right(tAuthUser));
      verify(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'Should throw Exception when signup method on the AuthRepository throws an Exception',
    () async {
      when(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).thenThrow(Exception());

      expect(
        () async => await signInUseCase.call(tSignInParams),
        throwsA(isA<Exception>()),
      );
    },
  );
}
