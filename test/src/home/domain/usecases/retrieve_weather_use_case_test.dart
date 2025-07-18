import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';
import 'package:movie_app/src/home/domain/repositories/weather_repository.dart';
import 'package:movie_app/src/home/domain/usecases/retrieve_weather_use_case.dart';

// Create a mock
class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late RetrieveWeatherUseCase useCase;
  late MockWeatherRepository mockRepo;

  setUp(() {
    mockRepo = MockWeatherRepository();
    useCase = RetrieveWeatherUseCase(weatherRepository: mockRepo);
  });

  const tParams = RetrieveWeatherParams(
    longitude: '24.7136',
    latitude: '46.6753',
  );
  final tWeather = Weather.empty();

  test('should return Weather when repository call is successful', () async {
    // Arrange
    when(
      () => mockRepo.retrieveWeather(
        longitude: any(named: 'longitude'),
        latitude: any(named: 'latitude'),
      ),
    ).thenAnswer((_) async => Right(tWeather));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, Right(tWeather));
    verify(
      () => mockRepo.retrieveWeather(
        longitude: tParams.longitude,
        latitude: tParams.latitude,
      ),
    );
    verifyNoMoreInteractions(mockRepo);
  });

  test('should throw Exception when repository throws', () async {
    // Arrange
    when(
      () => mockRepo.retrieveWeather(
        longitude: any(named: 'longitude'),
        latitude: any(named: 'latitude'),
      ),
    ).thenThrow(Exception('Something went wrong'));

    // Act & Assert
    expect(() => useCase(tParams), throwsA(isA<Exception>()));

    verify(
      () => mockRepo.retrieveWeather(
        longitude: tParams.longitude,
        latitude: tParams.latitude,
      ),
    );
    verifyNoMoreInteractions(mockRepo);
  });
}
