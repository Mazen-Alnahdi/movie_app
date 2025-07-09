import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/core/utils/validators.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_up_use_case.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required SignUpUseCase signUpUseCase})
    : _signUpUseCase = signUpUseCase,
      super(const SignUpInitial());

  final SignUpUseCase _signUpUseCase;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const SignUpInProgress());

    //check first before adding new user
    if (!Validators.isValidName(name)) {
      emit(SignUpFailed('Invalid Name Format'));
      return;
    }

    if (!Validators.isValidEmail(email)) {
      emit(SignUpFailed('Invalid Email Format'));
      return;
    }

    if (!Validators.isValidPassword(password)) {
      emit(
        SignUpFailed(
          'Password must be at least 6 characters and contain at least one number',
        ),
      );
      return;
    }

    emit(const SignUpValid());

    final result = await _signUpUseCase(
      SignUpParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) => emit(SignUpFailed(failure.message)),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}
