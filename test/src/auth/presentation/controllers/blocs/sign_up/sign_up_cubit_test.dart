import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_up_use_case.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_up/sign_up_cubit.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  late SignUpUseCase mockSignUp;
  late SignUpCubit cubit;

  const tAuthUser = AuthUser(id: '213', email: 'test@test.com', name: 'test');
  const tSignUpParams = SignUpParams(
    name: 'test',
    email: 'test@test.com',
    password: 'password1',
  );
  //failed regex for email
  const fSignUpParams = SignUpParams(
    name: 'name',
    email: 'email',
    password: 'password1',
  );

  const tServerFailure = ServerFailure(message: 'message', statusCode: '400');

  setUp(() {
    mockSignUp = MockSignUpUseCase();
    cubit = SignUpCubit(signUpUseCase: mockSignUp);
    registerFallbackValue(tSignUpParams);
  });

  tearDown(() => cubit.close());

  test('initial State should be SignUpInitial', () async {
    expect(cubit.state, const SignUpInitial());
  });

  group('SignUpStates', () {
    blocTest<SignUpCubit, SignUpState>(
      'Should emit [SignUpInProgress, SignUpValid, SignUpSuccess] when successful',
      build: () {
        when(() => mockSignUp(any())).thenAnswer((_) async => Right(tAuthUser));
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        name: tSignUpParams.name,
        email: tSignUpParams.email,
        password: tSignUpParams.password,
      ),
      expect: () => const [
        SignUpInProgress(),
        SignUpValid(),
        SignUpSuccess(tAuthUser),
      ],
      verify: (_) {
        verify(() => mockSignUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(mockSignUp);
      },
    );

    blocTest<SignUpCubit, SignUpState>(
      'Should emit [SignUpInProgress,SignUpValid, SignUpFailed] when unsuccessful',
      build: () {
        when(
          () => mockSignUp(any()),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        name: tSignUpParams.name,
        email: tSignUpParams.email,
        password: tSignUpParams.password,
      ),
      expect: () => [
        SignUpInProgress(),
        SignUpValid(),
        SignUpFailed(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => mockSignUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(mockSignUp);
      },
    );
    blocTest<SignUpCubit, SignUpState>(
      'Should emit [SignUpInProgress, SignUpFailed] when validating email',
      build: () {
        when(() => mockSignUp(any())).thenAnswer((_) async => Right(tAuthUser));
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        name: fSignUpParams.name,
        email: fSignUpParams.email,
        password: fSignUpParams.password,
      ),
      expect: () => [SignUpInProgress(), SignUpFailed('Invalid Email Format')],
      verify: (_) {
        verifyNever(() => mockSignUp(tSignUpParams));
        verifyNoMoreInteractions(mockSignUp);
      },
    );
  });
}
