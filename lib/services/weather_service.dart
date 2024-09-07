import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String? apiKey = dotenv.env['WEATHER_API_KEY'];
  final String forecastBaseUrl = "http://api.weatherapi.com/v1/forecast.json";
  final String searchBaseUrl = "http://api.weatherapi.com/v1/search.json";

  Future<Map<String, dynamic>> getTodayWeather(String location) async {
    final url =
        '$forecastBaseUrl?key=$apiKey&q=$location&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> get7DayWeather(String location) async {
    final url =
        '$forecastBaseUrl?key=$apiKey&q=$location&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load forecast weather data');
    }
  }

  Future<List<dynamic>?> fetchCitySuggestion(String query) async {
    final url = '$searchBaseUrl?key=$apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
