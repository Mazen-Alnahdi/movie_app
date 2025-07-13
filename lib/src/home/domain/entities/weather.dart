import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final List<String> dateTime;
  final List<double> temperature;
  final List<int> cloudCover;
  final List<double> windSpeed;
  final List<int> relativeHumidity;
  final List<double> precipitation;
  final List<double> uvIndex;

  const Weather({
    required this.dateTime,
    required this.temperature,
    required this.cloudCover,
    required this.windSpeed,
    required this.relativeHumidity,
    required this.precipitation,
    required this.uvIndex,
  });

  const Weather.empty()
    : this(
        dateTime: const [],
        temperature: const [],
        cloudCover: const [],
        windSpeed: const [],
        precipitation: const [],
        relativeHumidity: const [],
        uvIndex: const [],
      );

  @override
  List<Object> get props => [
    dateTime,
    temperature,
    cloudCover,
    windSpeed,
    relativeHumidity,
    precipitation,
    uvIndex,
  ];
}
