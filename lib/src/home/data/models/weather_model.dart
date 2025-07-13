import 'dart:convert';

import 'package:movie_app/src/home/domain/entities/weather.dart';

import '../../../../core/utils/typedef.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.dateTime,
    required super.temperature,
    required super.cloudCover,
    required super.windSpeed,
    required super.precipitation,
    required super.relativeHumidity,
    required super.uvIndex,
  });

  const WeatherModel.empty()
    : this(
        dateTime: const [],
        temperature: const [],
        cloudCover: const [],
        windSpeed: const [],
        precipitation: const [],
        relativeHumidity: const [],
        uvIndex: const [],
      );

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(jsonDecode(source) as DataMap);

  String toJson() => jsonEncode(toMap());

  Weather copyWith({
    List<String>? dateTime,
    List<double>? temperature,
    List<int>? cloudCover,
    List<double>? windSpeed,
    List<int>? relativeHumidity,
    List<double>? precipitation,
    List<double>? uvIndex,
  }) {
    return WeatherModel(
      dateTime: dateTime ?? this.dateTime,
      temperature: temperature ?? this.temperature,
      cloudCover: cloudCover ?? this.cloudCover,
      windSpeed: windSpeed ?? this.windSpeed,
      relativeHumidity: relativeHumidity ?? this.relativeHumidity,
      precipitation: precipitation ?? this.precipitation,
      uvIndex: uvIndex ?? this.uvIndex,
    );
  }

  DataMap toMap() {
    return {
      'dateTime': dateTime,
      'temperature': temperature,
      'cloudCover': cloudCover,
      'windSpeed': windSpeed,
      'relativeHumidity': relativeHumidity,
      'precipitation': precipitation,
      'uvIndex': uvIndex,
    };
  }

  factory WeatherModel.fromMap(DataMap map) {
    return WeatherModel(
      dateTime: List<String>.from(map['dateTime'] ?? []),
      temperature: (map['temperature'] ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      cloudCover: (map['cloudCover'] ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      windSpeed: (map['windSpeed'] ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      relativeHumidity: (map['relativeHumidity'] ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      precipitation: (map['precipitation'] ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      uvIndex: (map['uvIndex'] ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
