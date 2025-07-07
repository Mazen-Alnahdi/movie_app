import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_out_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signOutUseCase = SignOutUseCase(authRepository: mockAuthRepository);
  });

  test('should call signOut method on the AuthRepository', () async {
    when(
      () => mockAuthRepository.signOut(),
    ).thenAnswer((_) async => Right(null));

    await signOutUseCase.call();

    verify(() => mockAuthRepository.signOut());
  });

  test(
    'Should throw an Exception when the signout method on the AuthRepository throws an Exception',
    () async {
      when(() => mockAuthRepository.signOut()).thenThrow(Exception());

      expect(
        () async => await signOutUseCase.call(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
