import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_container.dart';
import 'package:weather_app/screens/forecast_screen.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = 'Jalandhar';
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final currentWeatherData = await _weatherService.getTodayWeather(_city);
      setState(() {
        _weatherData = currentWeatherData;
      });
    } on Exception {
      return QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Internet Connection Failed");
    }
  }

  void showCitySuggestion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter city name'),
            titleTextStyle: const TextStyle(fontSize: 15),
            content: TypeAheadField(
              suggestionsCallback: (search) async {
                return await _weatherService.fetchCitySuggestion(search);
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              },
              itemBuilder: (context, value) => ListTile(
                title: Text(value['name']),
              ),
              onSelected: (city) => setState(() {
                _city = city['name'];
                Navigator.pop(context);
                fetchWeather();
              }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _weatherData == null || _weatherData!.isEmpty
            ? Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 170)
                    ])),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 170)
                    ])),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: showCitySuggestion,
                          child: Text(_city,
                              style: GoogleFonts.lato(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image(
                            image: CachedNetworkImageProvider(
                              'https:${_weatherData!['current']['condition']['icon']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          '${_weatherData!['current']['temp_c']}°C',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '${_weatherData!['current']['condition']['text']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                'Max: ${_weatherData!['forecast']['forecastday'][0]['day']['maxtemp_c']}°C',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.white)),
                            Text(
                              'Min: ${_weatherData!['forecast']['forecastday'][0]['day']['mintemp_c']}°C',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: const Color.fromARGB(
                                          255, 202, 200, 200)),
                            ),
                          ],
                        )
                      ],
                    )),
                    const SizedBox(
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildWeatherDeatails(
                              label: 'Sunrise',
                              icon: Icons.wb_sunny,
                              value: _weatherData!['forecast']['forecastday'][0]
                                  ['astro']['sunrise']),
                          _buildWeatherDeatails(
                              label: 'Sunset',
                              icon: Icons.wb_twighlight,
                              value: _weatherData!['forecast']['forecastday'][0]
                                  ['astro']['sunset']),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildWeatherDeatails(
                              label: 'Humidity',
                              icon: Icons.opacity,
                              value: _weatherData!['current']['humidity']),
                          _buildWeatherDeatails(
                              label: 'Wind (kph)',
                              icon: Icons.wind_power,
                              value: _weatherData!['current']['wind_kph']),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForecastScreen(city: _city)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(20),
                              backgroundColor:
                                  const Color.fromARGB(255, 66, 39, 92)),
                          child: const Text(
                            "Next 7 days forecast",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ));
  }

  Widget _buildWeatherDeatails(
      {required String label, required IconData icon, required dynamic value}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  const Color(0xFF1A2344).withOpacity(0.5),
                  const Color(0xFF1A2344).withOpacity(0.2),
                ]),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                value is String ? value : value.toString(),
                style: GoogleFonts.lato(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
