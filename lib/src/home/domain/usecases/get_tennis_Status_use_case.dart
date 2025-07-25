import 'package:equatable/equatable.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/home/domain/repositories/weather_repository.dart';

class GetTennisStatusUseCase
    extends UsecaseWithParams<int, GetTennisStatusParams> {
  final WeatherRepository weatherRepository;

  GetTennisStatusUseCase({required this.weatherRepository});

  @override
  ResultFuture<int> call(GetTennisStatusParams params) async {
    try {
      Result<int> status = await weatherRepository.getTennisStatus(
        temperature: params.temperature,
        humidity: params.humidity,
        weatherCode: params.weatherCode,
      );
      return status;
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class GetTennisStatusParams extends Equatable {
  final double temperature;
  final int humidity;
  final int weatherCode;

  const GetTennisStatusParams({
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [temperature, humidity, weatherCode];
}
