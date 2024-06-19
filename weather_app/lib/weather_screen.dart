import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/item_additional_information.dart';
import 'package:weather_app/item_forecast.dart';
import 'package:weather_app/secrets.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> weather;
  var cityName = "";
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      const myLat = "20.1686954";
      const myLon = "106.2567362";
      var urlForecast = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?lat=$myLat&lon=$myLon&units=metric&lang=vi&appid=$openWeatherAPIKey");
      final res = await http.get(urlForecast);
      final data = jsonDecode(res.body.toString());
      if (int.parse(data['cod']) != 200) {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
    weather.then((data) {
      cityName = data['city']['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            cityName.isEmpty ? "Weather App" : cityName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    weather = getCurrentWeather();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }

            final data = snapshot.data!;
            final temp = data['list'][0]['main']['temp'].toString();
            final idImage = data['list'][0]['weather'][0]['icon'];
            final imageWeather =
                'https://openweathermap.org/img/wn/$idImage@2x.png';
            // final status = data['list'][0]['weather'][0]['main'];
            final description =
                data['list'][0]['weather'][0]['description'].toString();
            final humidity = data['list'][0]['main']['humidity'].toString();
            final pressure = data['list'][0]['main']['pressure'].toString();
            final windspeed = data['list'][0]['wind']['speed'].toString();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                children: [
                                  Text(
                                    temp.isNotEmpty ? "$temp ℃" : temp,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Image.network(imageWeather.isNotEmpty
                                      ? imageWeather
                                      : "https://openweathermap.org/themes/openweathermap/assets/img/logo_white_cropped.png"),
                                  Text(
                                    description.isNotEmpty
                                        ? description.capitaliseFirstLetter()
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            final hourlyForecast = data['list'][index + 1];
                            final time = DateTime.parse(
                                hourlyForecast['dt_txt'].toString());
                            return ForecastItem(
                              time: DateFormat.Hm().format(time),
                              image:
                                  'https://openweathermap.org/img/wn/${hourlyForecast['weather'][0]['icon']}@2x.png',
                              temperature:
                                  hourlyForecast['main']['temp'].toString(),
                            );
                          }),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ItemAdditionalInformation(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: humidity,
                        ),
                        ItemAdditionalInformation(
                          icon: Icons.air,
                          label: "Wind speed",
                          value: windspeed,
                        ),
                        ItemAdditionalInformation(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: pressure,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension CapitaliseFirstLetter on String {
  String capitaliseFirstLetter() {
    return this[0].toUpperCase() + substring(1);
  }
}

extension GetTimeFromDatetime on String {
  String getTimeFromDatetime() {
    return split(" ")[1];
  }
}
