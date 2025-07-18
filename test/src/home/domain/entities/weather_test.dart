import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/src/home/domain/entities/weather.dart';

void main() {
  test('Empty Weather with correct default values', () {
    expect(Weather.empty().dateTime, equals(const []));
    expect(Weather.empty().temperature, equals(const []));
    expect(Weather.empty().cloudCover, equals(const []));
    expect(Weather.empty().windSpeed, equals(const []));
    expect(Weather.empty().precipitation, equals(const []));
    expect(Weather.empty().relativeHumidity, equals(const []));
    expect(Weather.empty().uvIndex, equals(const []));
  });

  test('Two Weather instances with same values are equal', () {
    const weather1 = Weather(
      dateTime: [],
      temperature: [],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );
    const weather2 = Weather(
      dateTime: [],
      temperature: [],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );

    expect(weather1, equals(weather2));
  });

  test('Two Weather instances with different values are not equal', () {
    const weather1 = Weather(
      dateTime: [],
      temperature: [],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );
    const weather2 = Weather(
      dateTime: [],
      temperature: [1],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );

    expect(weather1, isNot(equals(weather2)));
  });

  test('Props return with correct properties', () {
    const weather1 = Weather(
      dateTime: [],
      temperature: [],
      cloudCover: [],
      windSpeed: [],
      relativeHumidity: [],
      precipitation: [],
      uvIndex: [],
    );
    expect(weather1.props, equals([[], [], [], [], [], [], []]));
  });
}
