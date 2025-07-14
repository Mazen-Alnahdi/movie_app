import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/src/home/data/datasources/weather_remote_data_source.dart';
import 'package:movie_app/src/home/data/models/weather_model.dart';
import 'package:movie_app/src/home/data/repository/weather_repository_implementation.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  late WeatherRemoteDataSource remoteDataSource;
  late WeatherRepositoryImplementation repository;
  late WeatherModel tWeatherModel;

  setUp(() {
    remoteDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImplementation(remoteDataSource);
    tWeatherModel = WeatherModel.empty();
  });

  const tException = APIException(message: 'Unknown Error', statusCode: "500");

  const longitude = "30";
  const latitude = "30";

  group('retrieveWeather', () {
    test('should return [Weather] when remote call is successful', () async {
      // Arrange
      when(
        () => remoteDataSource.retrieveWeather(
          longitude: longitude,
          latitude: latitude,
        ),
      ).thenAnswer((_) async => tWeatherModel);

      // Act
      final result = await repository.retrieveWeather(
        longitude: longitude,
        latitude: latitude,
      );

      // Assert
      expect(result, equals(Right(tWeatherModel as Weather)));
      verify(
        () => remoteDataSource.retrieveWeather(
          longitude: longitude,
          latitude: latitude,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
      'should return [Failure] when remote call throws APIException',
      () async {
        // Arrange
        when(
          () => remoteDataSource.retrieveWeather(
            longitude: longitude,
            latitude: latitude,
          ),
        ).thenThrow(tException);

        // Act
        final result = await repository.retrieveWeather(
          longitude: longitude,
          latitude: latitude,
        );

        // Assert
        expect(result, isA<Left<Failure, Weather>>());
        expect(result, equals(Left(APIFailure.fromException(tException))));
      },
    );
  });
}
