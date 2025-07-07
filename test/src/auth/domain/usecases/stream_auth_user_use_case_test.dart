import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';
import 'package:movie_app/src/auth/domain/usecases/stream_auth_user_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late StreamAuthUserUseCase streamAuthUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    streamAuthUserUseCase = StreamAuthUserUseCase(
      authRepository: mockAuthRepository,
    );
  });

  const tAuthUser = AuthUser(id: '123', email: 'test@test.com');

  test('should call authUser getter on the AuthRepository', () async {
    when(
      () => mockAuthRepository.authUser,
    ).thenAnswer((_) => Stream.value(Right(tAuthUser)));

    streamAuthUserUseCase.call();

    verify(() => mockAuthRepository.authUser);
  });

  test(
    'should throw Exception when the authGetter on the AuthRepository throws an exception',
    () async {
      when(() => mockAuthRepository.authUser).thenThrow(Exception());

      final call = streamAuthUserUseCase.call;

      expect(() => call(), throwsA(isInstanceOf<Exception>()));
    },
  );
}
