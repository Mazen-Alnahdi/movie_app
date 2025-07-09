import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_in_use_case.dart';

import '../../../../../../core/utils/validators.dart';
import '../../../../domain/entities/auth_user.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase,
      super(SignInInitial());

  final SignInUseCase _signInUseCase;

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInInProgress());

    if (!Validators.isValidEmail(email)) {
      emit(SignInFailed('Invalid Email'));
      return;
    }

    if (!Validators.isValidPassword(password)) {
      emit(SignInFailed('Invalid Password'));
      return;
    }

    //Log In Valid
    emit(const SignInValid());

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(SignInFailed(failure.message)),
      (user) => emit(SignInSuccess(user)),
    );
  }
}
