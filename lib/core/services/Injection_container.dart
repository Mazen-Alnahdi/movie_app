import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/auth/data/repository/auth_repository_implementation.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_in_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_out_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_up_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/stream_auth_user_use_case.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_in/sign_in_cubit.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_up/sign_up_cubit.dart';

import '../../src/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //Application Logic
    ..registerFactory(() => SignInCubit(signInUseCase: sl()))
    ..registerFactory(() => SignUpCubit(signUpUseCase: sl()))
    //use cases
    ..registerLazySingleton(() => SignInUseCase(authRepository: sl()))
    ..registerLazySingleton(() => SignUpUseCase(authRepository: sl()))
    //NOT USED YET
    ..registerLazySingleton(() => SignOutUseCase(authRepository: sl()))
    ..registerLazySingleton(() => StreamAuthUserUseCase(authRepository: sl()))
    //Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation(authRemoteDataSource: sl()),
    )
    //Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(
        fireStore: sl(),
        firebaseAuth: sl(),
      ),
    )
    //External Dependencies
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance);
}
