import 'package:equatable/equatable.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase extends UsecaseWithParams<AuthUser, SignUpParams> {
  final AuthRepository authRepository;
  SignUpUseCase({required this.authRepository});

  @override
  ResultFuture<AuthUser> call(SignUpParams params) async {
    try {
      Result<AuthUser> authUser = await authRepository.signUp(
        name: params.name,
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

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}
