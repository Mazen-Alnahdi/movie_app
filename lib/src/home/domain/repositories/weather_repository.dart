import 'package:movie_app/core/utils/typedef.dart';

import '../entities/weather.dart';

abstract class WeatherRepository {
  ResultFuture<Weather> retrieveWeather({
    required String longitude,
    required String latitude,
  });
}
