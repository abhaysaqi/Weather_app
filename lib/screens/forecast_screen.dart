import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:weather_app/services/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;
  const ForecastScreen({super.key, required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  List<dynamic>? _forecastWeatherData;

  @override
  void initState() {
    super.initState();
    fetchForecastWeather();
  }

  Future<void> fetchForecastWeather() async {
    try {
      final currentForecastData =
          await _weatherService.get7DayWeather(widget.city);
      setState(() {
        _forecastWeatherData = currentForecastData['forecast']['forecastday'];
      });
    } on Exception {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Internal erro check internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _forecastWeatherData == null || _forecastWeatherData!.isEmpty
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
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_rounded,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              '7 Days Forecast',
                              style: GoogleFonts.lato(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _forecastWeatherData!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final day = _forecastWeatherData![index];
                            String iconUrl =
                                'http:${day['day']['condition']['icon']}';
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin:
                                                AlignmentDirectional.topStart,
                                            end: AlignmentDirectional.bottomEnd,
                                            colors: [
                                              const Color(0xFF1A2344)
                                                  .withOpacity(0.5),
                                              const Color(0xFF1A2344)
                                                  .withOpacity(0.2),
                                            ])),
                                    child: ListTile(
                                      // contentPadding: const EdgeInsets.all(10),
                                      leading: SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              iconUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        '${day['date']}\n ${day['day']['avgtemp_c']}°C',
                                        style: GoogleFonts.lato(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        day['day']['condition']['text'],
                                        style: GoogleFonts.lato(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      trailing: Text(
                                        'max:${day['day']['maxtemp_c']}°C\n min:${day['day']['mintemp_c']}°C',
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
