import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/src/home/data/models/weather_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/typedef.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> retrieveWeather({
    required String longitude,
    required String latitude,
  });
  Future<int> getTennisStatus({
    required double temperature,
    required int humidity,
    required int weatherCode,
  });
}

String kRetrieveWeatherEndpoint = "/v1/forecast";

class WeatherRemoteDataSourceImplementation implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<WeatherModel> retrieveWeather({
    required String longitude,
    required String latitude,
  }) async {
    final queryParameters = {
      'latitude': latitude,
      'longitude': longitude,
      'hourly':
          'temperature_2m,cloud_cover,wind_speed_10m,relative_humidity_2m,precipitation,uv_index,weather_code',
      'timezone': 'auto',
    };

    try {
      final uri = Uri.https(
        kBaseUrl,
        kRetrieveWeatherEndpoint,
        queryParameters,
      );
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode.toString(),
        );
      }
      final DataMap jsonResponse = jsonDecode(response.body);
      return WeatherModel.fromApiJson(jsonResponse);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: "505");
    }
  }

  @override
  Future<int> getTennisStatus({
    required double temperature,
    required int humidity,
    required int weatherCode,
  }) async {
    int outlookRainy = 0;
    int outlookSunny = 0;
    int temperatureHot = 0;
    int temperatureMild = 0;
    int humidityNormal = 0;

    if (temperature < 18) {
      temperatureMild = 0;
      temperatureHot = 0;
    } else if (temperature >= 18 && temperature <= 27) {
      temperatureHot = 0;
      temperatureMild = 1;
    } else if (temperature > 27) {
      temperatureHot = 1;
      temperatureMild = 0;
    }

    switch (weatherCode) {
      case 0:
      case 1:
      case 2:
      case 3:
        {
          outlookSunny = 1;
          outlookRainy = 0;
        }
      default:
        {
          outlookSunny = 0;
          outlookRainy = 1;
        }
    }

    if (humidity < 30 || humidity > 60) {
      humidityNormal = 0;
    } else if (humidity >= 30 && humidity <= 60) {
      humidityNormal = 1;
    }

    List<int> features = [
      outlookRainy,
      outlookSunny,
      temperatureHot,
      temperatureMild,
      humidityNormal,
    ];
    final url = Uri.parse('http://127.0.0.1:5001/predict');

    Map<String, dynamic> body = {'features': features};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode.toString(),
        );
      }
      final prediction = json.decode(response.body)['prediction'];
      return prediction;
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '505');
    }
  }
}
