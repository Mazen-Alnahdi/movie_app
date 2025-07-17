import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/src/auth/data/repository/auth_repository_implementation.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_in_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_out_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/sign_up_use_case.dart';
import 'package:movie_app/src/auth/domain/usecases/stream_auth_user_use_case.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_in/sign_in_cubit.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_up/sign_up_cubit.dart';
import 'package:movie_app/src/home/data/datasources/weather_remote_data_source.dart';
import 'package:movie_app/src/home/data/repository/weather_repository_implementation.dart';
import 'package:movie_app/src/home/domain/repositories/weather_repository.dart';
import 'package:movie_app/src/home/domain/usecases/retrieve_weather_use_case.dart';
import 'package:movie_app/src/home/presentation/blocs/retrieve_weather/retrieve_weather_cubit.dart';

import '../../src/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //External Dependencies
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton<http.Client>(() => http.Client())
    //Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(
        fireStore: sl(),
        firebaseAuth: sl(),
      ),
    )
    ..registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImplementation(sl()),
    )
    //Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation(authRemoteDataSource: sl()),
    )
    ..registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImplementation(sl()),
    )
    //use cases
    ..registerLazySingleton(() => SignInUseCase(authRepository: sl()))
    ..registerLazySingleton(() => SignUpUseCase(authRepository: sl()))
    ..registerLazySingleton(
      () => RetrieveWeatherUseCase(weatherRepository: sl()),
    )
    //NOT USED YET
    ..registerLazySingleton(() => SignOutUseCase(authRepository: sl()))
    ..registerLazySingleton(() => StreamAuthUserUseCase(authRepository: sl()))
    //Application Logic
    ..registerFactory(() => SignInCubit(signInUseCase: sl()))
    ..registerFactory(() => SignUpCubit(signUpUseCase: sl()))
    ..registerFactory(() => RetrieveWeatherCubit(retrieveWeatherUseCase: sl()));
}
