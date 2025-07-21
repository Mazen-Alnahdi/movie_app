import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/src/home/data/datasources/weather_remote_data_source.dart';
import 'package:movie_app/src/home/data/models/weather_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late WeatherRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherRemoteDataSourceImplementation(mockHttpClient);
  });

  const tLatitude = '30.064054131743653';
  const tLongitude = '31.486013957930385';

  final tUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
    'latitude': tLatitude,
    'longitude': tLongitude,
    'hourly':
        'temperature_2m,cloud_cover,wind_speed_10m,relative_humidity_2m,precipitation,uv_index,weather_code',
    'timezone': 'auto',
  });

  test('should return WeatherModel when response is 200', () async {
    final jsonString = fixture('weather.json');
    final expectedModel = WeatherModel.fromApiJson(jsonDecode(jsonString));

    when(
      () => mockHttpClient.get(tUri),
    ).thenAnswer((_) async => http.Response(jsonString, 200));

    final result = await dataSource.retrieveWeather(
      latitude: tLatitude,
      longitude: tLongitude,
    );

    expect(result, equals(expectedModel));
  });

  test('should throw APIException when statusCode is not 200', () async {
    when(
      () => mockHttpClient.get(tUri),
    ).thenAnswer((_) async => http.Response('Server error', 500));

    expect(
      () => dataSource.retrieveWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      ),
      throwsA(isA<APIException>()),
    );
  });

  test('should return WeatherModel.empty when data is empty', () async {
    final emptyJson = jsonEncode({'hourly': {}});

    when(
      () => mockHttpClient.get(tUri),
    ).thenAnswer((_) async => http.Response(emptyJson, 200));

    final result = await dataSource.retrieveWeather(
      latitude: tLatitude,
      longitude: tLongitude,
    );

    expect(result, WeatherModel.empty());
  });
}
