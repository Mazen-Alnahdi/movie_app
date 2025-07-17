import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<DateTime> next7Days = List.generate(7, (i) {
      return today.add(Duration(days: i));
    });

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
          children: List.generate(next7Days.length, (index) {
            final day = next7Days[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onDateSelected(index),
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
                      _getDayName(day),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${day.day}",
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

  String _getDayName(DateTime date) {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekDays[date.weekday % 7];
  }
}
