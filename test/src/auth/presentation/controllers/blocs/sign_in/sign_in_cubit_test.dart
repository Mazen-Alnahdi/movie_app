import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_in_use_case.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_in/sign_in_cubit.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

void main() {
  late SignInUseCase mockSignIn;
  late SignInCubit cubit;

  const tAuthUser = AuthUser(id: '123', email: 'test@test.com', name: 'test');
  const tSignInParams = SignInParams(
    email: 'test@gmail.com',
    password: 'password1234',
  );

  //failed regex for email
  const fSignInParams = SignInParams(email: 'test', password: 'password1');

  const gSignInParams = SignInParams(
    email: 'test@test.com',
    password: 'password',
  );

  const tServerFailure = ServerFailure(
    message: 'message',
    statusCode: 'statusCode',
  );

  setUp(() {
    mockSignIn = MockSignInUseCase();
    cubit = SignInCubit(signInUseCase: mockSignIn);
    registerFallbackValue(tSignInParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be SignInInitial', () async {
    expect(cubit.state, const SignInInitial());
  });

  group('SignIn', () {
    blocTest<SignInCubit, SignInState>(
      'Should emit [SignInInProgress, SignInValid, SignInSuccess] when successful',
      build: () {
        when(() => mockSignIn(any())).thenAnswer((_) async => Right(tAuthUser));
        return cubit;
      },
      act: (cubit) => cubit.signIn(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),
      expect: () => const [
        SignInInProgress(),
        SignInValid(),
        SignInSuccess(tAuthUser),
      ],
      verify: (_) {
        verify(() => mockSignIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(mockSignIn);
      },
    );
    blocTest<SignInCubit, SignInState>(
      'Should emit [SignInInProgress, SignInValid, SignInFailed] when sign in fails',
      build: () {
        when(
          () => mockSignIn(tSignInParams),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.signIn(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),
      expect: () => [
        const SignInInProgress(),
        const SignInValid(),
        SignInFailed(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => mockSignIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(mockSignIn);
      },
    );

    blocTest<SignInCubit, SignInState>(
      'Should emit [SignInInProgress, SignInFailed] when validating email',
      build: () {
        when(() => mockSignIn(any())).thenAnswer((_) async => Right(tAuthUser));
        return cubit;
      },
      act: (cubit) => cubit.signIn(
        email: fSignInParams.email,
        password: fSignInParams.password,
      ),
      expect: () => [SignInInProgress(), SignInFailed('Invalid Email')],
      verify: (_) {
        verifyNever(() => mockSignIn(tSignInParams));
        verifyNoMoreInteractions(mockSignIn);
      },
    );
    blocTest<SignInCubit, SignInState>(
      'Should emit [SignInInProgress, SignInFailed] when validating password',
      build: () {
        when(() => mockSignIn(any())).thenAnswer((_) async => Right(tAuthUser));
        return cubit;
      },
      act: (cubit) => cubit.signIn(
        email: gSignInParams.email,
        password: gSignInParams.password,
      ),
      expect: () => [SignInInProgress(), SignInFailed('Invalid Password')],
      verify: (_) {
        verifyNever(() => mockSignIn(tSignInParams));
        verifyNoMoreInteractions(mockSignIn);
      },
    );
  });
}
