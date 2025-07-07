import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase extends UsecaseWithoutParams<void> {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  @override
  ResultVoid call() async => await authRepository.signOut();
}
