import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';
import 'package:movie_app/src/home/domain/usecases/retrieve_weather_use_case.dart';

part 'retrieve_weather_state.dart';

class RetrieveWeatherCubit extends Cubit<RetrieveWeatherState> {
  RetrieveWeatherCubit({required RetrieveWeatherUseCase retrieveWeatherUseCase})
    : _retrieveWeatherUseCase = retrieveWeatherUseCase,
      super(RetrieveWeatherInitial());

  final RetrieveWeatherUseCase _retrieveWeatherUseCase;

  Future<void> retrieveWeather({
    required String longitude,
    required String latitude,
  }) async {
    emit(const RetrieveWeatherInProgress());

    final result = await _retrieveWeatherUseCase(
      RetrieveWeatherParams(longitude: longitude, latitude: latitude),
    );
    result.fold(
      (failure) => emit(RetrieveWeatherFailed(failure.message)),
      (weather) => emit(RetrieveWeatherSuccess(weather)),
    );
  }
}
