// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/weather.dart';
import '../utils/static_data.dart';
import 'weather.dart';

class WeatherApi {
  String apiUrl = "https://api.openweathermap.org/data/";
  String apiVersion = "2.5/";

  Future<WeatherData> fetchWeatherData(BuildContext context) async {
    final weather = Provider.of<WeatherProvider>(context, listen: false);

    final response = await http.get(Uri.parse(
        "$apiUrl${apiVersion}weather?lat=${weather.lat}&lon=${weather.lon}&apiKey=${WeatherStaticData.apiKey}"));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<dynamic> weatherApi(BuildContext context) async {
    final weather = Provider.of<WeatherProvider>(context, listen: false);
    try {
      String url =
          "$apiUrl${apiVersion}weather?lat=${weather.lat}&lon=${weather.lon}&apiKey=${WeatherStaticData.apiKey}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
