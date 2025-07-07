import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';
import 'package:movie_app/src/auth/domain/repositories/auth_repository.dart';

class StreamAuthUserUseCase {
  final AuthRepository authRepository;

  StreamAuthUserUseCase({required this.authRepository});

  ResultStream<AuthUser> call() {
    try {
      return authRepository.authUser;
    } catch (error) {
      throw Exception(error);
    }
  }
}
