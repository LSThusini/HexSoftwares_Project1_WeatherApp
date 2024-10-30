import 'dart:convert';
import 'package:http/http.dart' as http;

const openWeatherApikey = 'd5f6e02714754f7b5619cd08ce036b75';

Future<Map<String, dynamic>> getCurrenttWeather(String cityName) async {
  try {
    final res = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApikey'),
    );

    final data = json.decode(res.body);

    if (data['cod'] != '200') {
      throw 'Unexpected error occured';
    }

    return data;
    //data['list'][0]['main']['temp'];
  } catch (e) {
    throw e.toString();
  }
}
