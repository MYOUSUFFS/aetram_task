import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/weather.dart';
import 'utils/static_data.dart';
import 'provider.dart';

class WeatherApi {
  String apiUrl = "https://api.openweathermap.org/data/";
  String apiVersion = "2.5/";

  Future<WeatherData> fetchWeatherData(BuildContext context) async {
    final weather = Provider.of<WeatherProvider>(context, listen: false);

    final position = await weather.setLatLog();

    final response = await http.get(Uri.parse(
        "$apiUrl${apiVersion}weather?lat=${position.latitude}&lon=${position.longitude}&apiKey=${WeatherStaticData.apiKey}"));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Forecast>?> fetchForecastData(BuildContext context) async {
    final weather = Provider.of<WeatherProvider>(context, listen: false);

    final response = await http.get(Uri.parse(
        "$apiUrl${apiVersion}forecast?lat=${weather.lat}&lon=${weather.lon}&apiKey=${WeatherStaticData.apiKey}"));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body)['list'] as List?;
      final dataList = list?.map((i) => Forecast.fromJson(i)).toList();
      return dataList;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
