import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';
import 'package:movie_app/src/home/domain/usecases/retrieve_weather_use_case.dart';
import 'package:movie_app/src/home/presentation/blocs/retrieve_weather/retrieve_weather_cubit.dart';

class MockRetrieveWeatherUseCase extends Mock
    implements RetrieveWeatherUseCase {}

void main() {
  late RetrieveWeatherCubit cubit;
  late MockRetrieveWeatherUseCase mockRetrieveWeather;

  const tParams = RetrieveWeatherParams(
    latitude: '46.6753',
    longitude: '24.7136',
  );
  final tWeather = Weather.empty();

  const tServerFailure = ServerFailure(message: 'message', statusCode: '500');

  setUp(() {
    mockRetrieveWeather = MockRetrieveWeatherUseCase();
    cubit = RetrieveWeatherCubit(retrieveWeatherUseCase: mockRetrieveWeather);
    registerFallbackValue(
      const RetrieveWeatherParams(latitude: '0.0', longitude: '0.0'),
    );
  });

  tearDown(() => cubit.close());

  group('RetrieveWeatherCubit', () {
    blocTest<RetrieveWeatherCubit, RetrieveWeatherState>(
      'emits [InProgress, Success] when retrieveWeather succeeds',
      build: () {
        when(
          () => mockRetrieveWeather(any()),
        ).thenAnswer((_) async => Right(tWeather));
        return cubit;
      },
      act: (cubit) => cubit.retrieveWeather(
        longitude: tParams.longitude,
        latitude: tParams.latitude,
      ),
      expect: () => [
        const RetrieveWeatherInProgress(),
        RetrieveWeatherSuccess(tWeather),
      ],
      verify: (_) {
        verify(() => mockRetrieveWeather.call(tParams)).called(1);
      },
    );

    blocTest<RetrieveWeatherCubit, RetrieveWeatherState>(
      'emits [InProgress, Failed] when retrieveWeather fails',
      build: () {
        when(
          () => mockRetrieveWeather(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.retrieveWeather(
        longitude: tParams.longitude,
        latitude: tParams.latitude,
      ),
      expect: () => [
        const RetrieveWeatherInProgress(),
        const RetrieveWeatherFailed('message'),
      ],
      verify: (_) {
        verify(() => mockRetrieveWeather.call(tParams)).called(1);
      },
    );
  });
}
