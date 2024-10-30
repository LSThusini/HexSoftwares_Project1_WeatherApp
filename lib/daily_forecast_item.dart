import 'package:flutter/material.dart';

class DailyForecast extends StatelessWidget {
  final String day;
  final String currentSky;
  final String temp;
  const DailyForecast(
      {super.key,
      required this.day,
      required this.currentSky,
      required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 6,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 90, child: Text(day)),
              Row(
                children: [
                  Icon(
                    currentSky == 'Clouds' || currentSky == 'Rain'
                        ? Icons.cloud
                        : Icons.sunny,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(currentSky),
                ],
              ),
              Text(
                temp,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
