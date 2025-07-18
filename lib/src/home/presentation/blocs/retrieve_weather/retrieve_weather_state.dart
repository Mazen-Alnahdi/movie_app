part of 'retrieve_weather_cubit.dart';

abstract class RetrieveWeatherState extends Equatable {
  const RetrieveWeatherState();

  @override
  List<Object> get props => [];
}

class RetrieveWeatherInitial extends RetrieveWeatherState {
  const RetrieveWeatherInitial();
}

class RetrieveWeatherInProgress extends RetrieveWeatherState {
  const RetrieveWeatherInProgress();
}

class RetrieveWeatherSuccess extends RetrieveWeatherState {
  const RetrieveWeatherSuccess(this.weather);

  final Weather weather;

  @override
  List<Object> get props => [weather];
}

class RetrieveWeatherFailed extends RetrieveWeatherState {
  const RetrieveWeatherFailed(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
