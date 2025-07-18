import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/home/data/datasources/weather_remote_data_source.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';

import '../../domain/repositories/weather_repository.dart';

class WeatherRepositoryImplementation implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;
  const WeatherRepositoryImplementation(this._remoteDataSource);

  @override
  ResultFuture<Weather> retrieveWeather({
    required String longitude,
    required String latitude,
  }) async {
    try {
      final result = await _remoteDataSource.retrieveWeather(
        longitude: longitude,
        latitude: latitude,
      );
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
