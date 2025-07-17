import 'package:equatable/equatable.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';
import 'package:movie_app/src/home/domain/repositories/weather_repository.dart';

class RetrieveWeatherUseCase
    extends UsecaseWithParams<Weather, RetrieveWeatherParams> {
  final WeatherRepository weatherRepository;

  RetrieveWeatherUseCase({required this.weatherRepository});

  @override
  ResultFuture<Weather> call(RetrieveWeatherParams params) async {
    try {
      Result<Weather> weather = await weatherRepository.retrieveWeather(
        longitude: params.longitude,
        latitude: params.latitude,
      );
      return weather;
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class RetrieveWeatherParams extends Equatable {
  final String longitude;
  final String latitude;

  const RetrieveWeatherParams({
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object> get props => [longitude, latitude];
}
