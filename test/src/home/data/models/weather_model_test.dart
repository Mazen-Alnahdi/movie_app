import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/utils/typedef.dart';
import 'package:movie_app/src/home/data/models/weather_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('WeatherModel', () {
    late DataMap fullJson;
    late DataMap hourlyMap;

    setUp(() {
      final jsonString = fixture('weather.json');
      fullJson = jsonDecode(jsonString) as DataMap;
      hourlyMap = fullJson['hourly'] as DataMap;
    });

    test('fromApiJson should parse full API JSON correctly', () {
      final model = WeatherModel.fromApiJson(fullJson);

      expect(model.dateTime.length, 2);
      expect(model.dateTime.first, DateTime.parse("2025-07-13T00:00:00Z"));
      expect(model.temperature, equals([25.5, 24.7]));
      expect(model.cloudCover, equals([20, 15]));
      expect(model.windSpeed, equals([5.5, 4.2]));
      expect(model.relativeHumidity, equals([60, 65]));
      expect(model.precipitation, equals([0.0, 0.1]));
      expect(model.uvIndex, equals([3.0, 2.5]));
    });

    test('fromMap should parse hourly map correctly', () {
      final model = WeatherModel.fromMap(hourlyMap);

      expect(model.temperature.length, 2);
      expect(model.windSpeed[1], 4.2);
    });

    test('toMap should return correct map structure', () {
      final model = WeatherModel.fromMap(hourlyMap);
      final map = model.toMap();

      expect(map['temperature_2m'], equals([25.5, 24.7]));
      expect(map['cloud_cover'], equals([20, 15]));
      expect(map['wind_speed_10m'], equals([5.5, 4.2]));
      expect(map['relative_humidity_2m'], equals([60, 65]));
      expect(map['uv_index'], equals([3.0, 2.5]));
    });

    test('toJson and fromJson should be symmetric', () {
      final model = WeatherModel.fromMap(hourlyMap);
      final jsonMap = model.toJson();
      final newModel = WeatherModel.fromJson(jsonMap);

      expect(newModel.temperature, equals(model.temperature));
      expect(newModel.windSpeed, equals(model.windSpeed));
      expect(
        newModel.dateTime.first.toIso8601String(),
        equals(model.dateTime.first.toIso8601String()),
      );
    });
  });
}
