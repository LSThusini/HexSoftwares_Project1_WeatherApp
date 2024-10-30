// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/daily_forecast_item.dart';
import 'package:weather_app/secrets.dart';

class NextDays extends StatefulWidget {
  final String cityName;
  const NextDays({
    super.key,
    required this.cityName,
  });

  @override
  State<NextDays> createState() => _NextDaysState();
}

class _NextDaysState extends State<NextDays> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather = getCurrenttWeather(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 133, 208),
        title: Text(widget.cityName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          //Data as it comes from the function.
          final data = snapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(
                      color: Colors.white,
                      Icons.calendar_month_outlined,
                      size: 36,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "This Week",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.vertical,
                    itemBuilder: ((context, index) {
                      final temparature =
                          data['list'][index]['main']['temp'] - 273.15;
                      final sky =
                          '${data['list'][index]['weather'][0]['main']}';

                      DateTime now = new DateTime.now();
                      List<String> nextSevenDays = [];

                      for (int i = 0; i < 8; i++) {
                        DateTime nextDay = now.add(Duration(days: i));
                        String dayOfWeek = DateFormat('EEEE').format(nextDay);
                        nextSevenDays.add(dayOfWeek);
                      }
                      return DailyForecast(
                        day: nextSevenDays[index + 1],
                        currentSky: sky,
                        temp: temparature.toStringAsFixed(2) + '°C',
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
