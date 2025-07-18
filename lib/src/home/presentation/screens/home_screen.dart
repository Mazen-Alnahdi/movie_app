import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/weather.dart';
import '../blocs/retrieve_weather/retrieve_weather_cubit.dart';

class HomeScreen extends StatefulWidget {
  final String displayName;

  const HomeScreen({super.key, required this.displayName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<int> filteredIndexes = [];

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
                      _buildDateSelector(weather),
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
                      _buildAdditionalData(weather, currentDataIndex),
                    ],
                  ),
                );
              }

              return const Center(
                child: Text(
                  "No data yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(Weather weather) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filteredIndexes.length, (index) {
            final i = filteredIndexes[index];
            final date = weather.dateTime[i];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.E().format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${date.day}",
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAdditionalData(Weather weather, int index) {
    final dataItems = [
      (
        "Temperature",
        "${weather.temperature[index].toStringAsFixed(1)}°C",
        Icons.thermostat,
      ),
      (
        "Wind Speed",
        "${weather.windSpeed[index].toStringAsFixed(1)} m/s",
        Icons.air,
      ),
      ("Cloud Cover", "${weather.cloudCover[index]}%", Icons.cloud),
      ("Humidity", "${weather.relativeHumidity[index]}%", Icons.water_drop),
      ("Precipitation", "${weather.precipitation[index]} mm", Icons.grain),
      (
        "UV Index",
        "${weather.uvIndex[index].toStringAsFixed(1)}",
        Icons.wb_sunny,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: dataItems.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$3, color: Colors.white, size: 30),
                const SizedBox(height: 10),
                Text(
                  item.$1,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// A widget for bottom nav item with icon and label
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    this.selected = false,
  }) : super(key: key);

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
