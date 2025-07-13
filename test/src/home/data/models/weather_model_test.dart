import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/home/data/models/weather_model.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockWeather extends Mock implements Weather {}

void main() {
  final tModel = WeatherModel.empty();

  test('should be a subclass of [Weather] entity', () {
    expect(tModel, isA<Weather>());
  });

  final tJson = fixture('weather.json');
  final tJsonTrimmed = fixture('weather.json');
  final tMap = jsonDecode(tJson);

  group('fromMap', () {
    test('should return a [WeatherModel] with the right data', () {
      final result = WeatherModel.fromMap(tMap);

      expect(result, equals(tModel));
    });
  });
}
