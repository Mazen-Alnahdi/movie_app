import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movie_app/src/home/presentation/blocs/get_tennis_status/get_tennis_status_cubit.dart';

import '../../domain/entities/weather.dart';
import '../blocs/retrieve_weather/retrieve_weather_cubit.dart';
import '../widgets/additional_data_widget.dart';
import '../widgets/data_selector_widget.dart';

class HomeScreen extends StatefulWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<int> filteredIndexes = [];
  int? tennisStatus;

  @override
  void initState() {
    super.initState();
    _retrieveWeather();
  }

  Future<void> _retrieveWeather() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    await context.read<RetrieveWeatherCubit>().retrieveWeather(
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );
  }

  void _updateTennisStatus(Weather weather) {
    final index = filteredIndexes.isNotEmpty
        ? filteredIndexes[selectedIndex]
        : 0;
    // print('$index is the index');

    final temperature = weather.temperature[index];
    final humidity = weather.relativeHumidity[index];
    final weatherCode = weather.weatherCode[index];

    context.read<GetTennisStatusCubit>().getTennisStatus(
      temperature: temperature,
      humidity: humidity,
      weatherCode: weatherCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetTennisStatusCubit, GetTennisStatusState>(
          listener: (context, state) {
            if (state is GetTennisStatusSuccess) {
              setState(() {
                tennisStatus = state.status;
                // print('$tennisStatus is the tennis status');
                // print('$state.status is the sate.status');
                // make sure it's `status`
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF011F8C),
        bottomNavigationBar: Container(
          height: 80,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(
                icon: Icons.star_border,
                label: "Favorites",
                selected: true,
              ),
              _NavItem(icon: Icons.shield_outlined, label: "Safety"),
              _NavItem(icon: Icons.home, label: "Home", selected: true),
              _NavItem(icon: Icons.check_box_outlined, label: "Checklist"),
              _NavItem(icon: Icons.settings, label: "Settings"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF031450), Color(0xFF011F8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
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
                  final now = DateTime.now();
                  final currentHour = now.hour;

                  filteredIndexes = [];
                  final Set<int> addedDays = {};

                  for (int i = 0; i < weather.dateTime.length; i++) {
                    final dt = weather.dateTime[i];
                    if (dt.hour == currentHour &&
                        dt.isAfter(now) &&
                        !addedDays.contains(dt.day)) {
                      filteredIndexes.add(i);
                      addedDays.add(dt.day);
                      if (filteredIndexes.length == 7) break;
                    }
                  }

                  final currentDataIndex = filteredIndexes.isNotEmpty
                      ? filteredIndexes[selectedIndex]
                      : 0;

                  // 🔁 Ensure tennisStatus is updated only once after indexes are ready
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // print("addpostfamecallback");
                    if (tennisStatus == null && filteredIndexes.isNotEmpty) {
                      _updateTennisStatus(weather);
                      // print("updatedTenis");
                    }
                  });

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Welcome,\n",
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        WeatherDateSelector(
                          filteredIndexes: filteredIndexes,
                          weather: weather,
                          selectedIndex: selectedIndex,
                          onSelected: (index) {
                            setState(() {
                              selectedIndex = index;
                              tennisStatus = null; // reset status on change
                            });

                            _updateTennisStatus(weather);
                          },
                        ),

                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Today's Weather",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        WeatherAdditionalData(
                          dataItems: [
                            (
                              "Temperature",
                              "${weather.temperature[currentDataIndex].toStringAsFixed(1)}°C",
                              Icons.thermostat,
                            ),
                            (
                              "Wind Speed",
                              "${weather.windSpeed[currentDataIndex].toStringAsFixed(1)} m/s",
                              Icons.air,
                            ),
                            (
                              "Cloud Cover",
                              "${weather.cloudCover[currentDataIndex]}%",
                              Icons.cloud,
                            ),
                            (
                              "Humidity",
                              "${weather.relativeHumidity[currentDataIndex]}%",
                              Icons.water_drop,
                            ),
                            (
                              "Precipitation",
                              "${weather.precipitation[currentDataIndex]} mm",
                              Icons.grain,
                            ),
                            (
                              "UV Index",
                              "${weather.uvIndex[currentDataIndex].toStringAsFixed(1)}",
                              Icons.wb_sunny,
                            ),
                            (
                              "Tennis Status",
                              tennisStatus == null
                                  ? "Loading..."
                                  : tennisStatus == 1
                                  ? "Good to Play"
                                  : "Not Recommended",
                              Icons.sports_tennis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom Navigation Item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
