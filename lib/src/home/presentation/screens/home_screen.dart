import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import '../blocs/retrieve_weather/retrieve_weather_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _retrieveWeather();
  }

  Future<void> _retrieveWeather() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    context.read<RetrieveWeatherCubit>().retrieveWeather(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011F8C),
      body: SafeArea(
        child: BlocBuilder<RetrieveWeatherCubit, RetrieveWeatherState>(
          builder: (context, state) {
            if (state is RetrieveWeatherInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RetrieveWeatherFailed) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is RetrieveWeatherSuccess) {
              final Weather weather = state.weather;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Hourly Forecast",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather.dateTime.length,
                      itemBuilder: (context, index) {
                        final date = weather.dateTime[index];
                        final temp = weather.temperature[index];
                        final wind = weather.windSpeed[index];

                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(left: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.Hm().format(date),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${temp.toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${wind.toStringAsFixed(1)} m/s",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Additional Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAdditionalData(weather),
                ],
              );
            }

            return const Center(
              child: Text("No data yet", style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdditionalData(Weather weather) {
    final latestIndex = weather.dateTime.isNotEmpty
        ? weather.dateTime.length - 1
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _dataTile("Cloud Cover", "${weather.cloudCover[latestIndex]}%"),
          _dataTile("Humidity", "${weather.relativeHumidity[latestIndex]}%"),
          _dataTile(
            "Precipitation",
            "${weather.precipitation[latestIndex]} mm",
          ),
          _dataTile(
            "UV Index",
            "${weather.uvIndex[latestIndex].toStringAsFixed(1)}",
          ),
        ],
      ),
    );
  }

  Widget _dataTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
