// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  dateTime: json['time'] == null
      ? []
      : WeatherModel._dateTimeFromJson(json['time'] as List),
  temperature:
      (json['temperature_2m'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      [],
  cloudCover:
      (json['cloud_cover'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  windSpeed:
      (json['wind_speed_10m'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      [],
  relativeHumidity:
      (json['relative_humidity_2m'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  precipitation:
      (json['precipitation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      [],
  uvIndex:
      (json['uv_index'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      [],
  weatherCode:
      (json['weather_code'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'time': WeatherModel._dateTimeToJson(instance.dateTime),
      'temperature_2m': instance.temperature,
      'cloud_cover': instance.cloudCover,
      'wind_speed_10m': instance.windSpeed,
      'relative_humidity_2m': instance.relativeHumidity,
      'precipitation': instance.precipitation,
      'uv_index': instance.uvIndex,
      'weather_code': instance.weatherCode,
    };
