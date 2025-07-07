import 'package:equatable/equatable.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';

import '../repositories/auth_repository.dart';

class SignInUseCase extends UsecaseWithParams<AuthUser, SignInParams> {
  final AuthRepository authRepository;
  SignInUseCase({required this.authRepository});

  @override
  ResultFuture<AuthUser> call(SignInParams params) async {
    try {
      Result<AuthUser> authUser = await authRepository.signIn(
        email: params.email,
        password: params.password,
      );
      return authUser;
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
