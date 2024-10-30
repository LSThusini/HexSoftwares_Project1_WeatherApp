import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/next_days_screen.dart';
import 'package:weather_app/secrets.dart';

//New comment
//Another comment
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late String cityName;
  late Future<Map<String, dynamic>> weather;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityName = "Durban";
    weather = getCurrenttWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 133, 208),
        title: Text(
          cityName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              weather = getCurrenttWeather(cityName);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Change Location")
                ],
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.of(context).pop();
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Text(
                              "Change location",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: locationController,
                              decoration: InputDecoration(
                                  hintText: "Enter new location",
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 133, 208),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    if (locationController.text.isNotEmpty) {
                                      setState(() {
                                        cityName = locationController.text;
                                        weather = getCurrenttWeather(cityName);
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),

      //App Body begins
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
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final humidity = currentWeatherData['main']['humidity'];
          final pressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ), // Adjusts how the image fills the space)),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  //Let the content take the maximum size of the card
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                currentTemp.toStringAsFixed(2) + '°C',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '$currentSky',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NextDays(
                            cityName: cityName,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        Colors.transparent, // Set the elevation here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Next Days",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 133, 208),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          color: Color.fromARGB(255, 0, 133, 208),
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                const Text(
                  "Hourly Forecust",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecastdata = data['list'][index + 1];
                      final hourlyTemp =
                          (hourlyForecastdata['main']['temp'] - 273.15)
                                  .toStringAsFixed(2) +
                              '°C';
                      final hourlySky =
                          hourlyForecastdata['weather'][0]['main'];
                      final time = DateTime.parse(
                          hourlyForecastdata['dt_txt'].toString());

                      return HourlyForecastItem(
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature: hourlyTemp,
                        time: DateFormat.Hm().format(time),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInforItem(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: "$humidity %",
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      AdditionalInforItem(
                        icon: Icons.air,
                        label: "Wind speed",
                        value: "$windSpeed",
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      AdditionalInforItem(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: "$pressure",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void changelocation(BuildContext cont) {
    showBottomSheet(
        context: cont,
        builder: (cont) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: const Column(
              children: [Text("Enter new Location"), TextField()],
            ),
          );
        });
  }

  DrawerHeader drawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.settings),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 32,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Current location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
