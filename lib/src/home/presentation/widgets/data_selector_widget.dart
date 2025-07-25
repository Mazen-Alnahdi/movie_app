import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/weather.dart';

class WeatherDateSelector extends StatelessWidget {
  final List<int> filteredIndexes;
  final Weather weather;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const WeatherDateSelector({
    super.key,
    required this.filteredIndexes,
    required this.weather,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: () => onSelected(index),
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
}
