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
          'temperature_2m,cloud_cover,wind_speed_10m,relative_humidity_2m,precipitation,uv_index',
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
}
