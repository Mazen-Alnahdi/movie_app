import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel extends Weather {
  @JsonKey(
    name: 'time',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
    defaultValue: [],
  )
  final List<DateTime> dateTime;

  @JsonKey(name: 'temperature_2m', defaultValue: [])
  final List<double> temperature;

  @JsonKey(name: 'cloud_cover', defaultValue: [])
  final List<int> cloudCover;

  @JsonKey(name: 'wind_speed_10m', defaultValue: [])
  final List<double> windSpeed;

  @JsonKey(name: 'relative_humidity_2m', defaultValue: [])
  final List<int> relativeHumidity;

  @JsonKey(name: 'precipitation', defaultValue: [])
  final List<double> precipitation;

  @JsonKey(name: 'uv_index', defaultValue: [])
  final List<double> uvIndex;

  const WeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.cloudCover,
    required this.windSpeed,
    required this.relativeHumidity,
    required this.precipitation,
    required this.uvIndex,
  }) : super(
         dateTime: dateTime,
         temperature: temperature,
         cloudCover: cloudCover,
         windSpeed: windSpeed,
         relativeHumidity: relativeHumidity,
         precipitation: precipitation,
         uvIndex: uvIndex,
       );

  /// Use this if you're passing the full API response (with 'hourly' field)
  factory WeatherModel.fromApiJson(Map<String, dynamic> json) {
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};
    return WeatherModel.fromMap(hourly);
  }

  /// Use this if you're passing just the hourly map directly
  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      dateTime:
          (map['time'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      temperature:
          (map['temperature_2m'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      cloudCover:
          (map['cloud_cover'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      windSpeed:
          (map['wind_speed_10m'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      relativeHumidity:
          (map['relative_humidity_2m'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      precipitation:
          (map['precipitation'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      uvIndex:
          (map['uv_index'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  factory WeatherModel.empty() {
    return const WeatherModel(
      dateTime: [],
      temperature: [],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );
  }

  Map<String, dynamic> toMap() => {
    'time': dateTime.map((e) => e.toIso8601String()).toList(),
    'temperature_2m': temperature,
    'cloud_cover': cloudCover,
    'wind_speed_10m': windSpeed,
    'relative_humidity_2m': relativeHumidity,
    'precipitation': precipitation,
    'uv_index': uvIndex,
  };

  /// Only use this with already-cleaned hourly maps (not full API)
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  /// Helper for DateTime conversion
  static List<DateTime> _dateTimeFromJson(List<dynamic> list) =>
      list.map((e) => DateTime.parse(e as String)).toList();

  static List<String> _dateTimeToJson(List<DateTime> list) =>
      list.map((e) => e.toIso8601String()).toList();
}
