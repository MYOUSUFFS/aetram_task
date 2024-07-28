import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/weather.dart';
import 'api.dart';
import 'utils/location_permission.dart';

class WeatherProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  loadChange(bool loadIs) {
    _isLoading = loadIs;
    notifyListeners();
  }

  WeatherData? _futureWeatherData;
  WeatherData? get futureWeatherData => _futureWeatherData;

  futureWeatherDataFn(
    BuildContext context,
  ) async {
    loadChange(true);
    WeatherData? value = await WeatherApi().fetchWeatherData(context);
    _futureWeatherData = value;
    _currentTemp = value.main.temp;
    loadChange(false);
    notifyListeners();
  }

  double? _currentTemp;
  double? get currentTemp => _currentTemp;

  String _temp = 'celsius';
  String get temp => _temp;

  tempFn(String value) {
    _temp = value;
    notifyListeners();
  }

  double? _lat;
  double? get lat => _lat;

  double? _lon;
  double? get lon => _lon;

  Future<Position> setLatLog() async {
    loadChange(true);
    Position position = await PositionIs().getCurrentLocation();
    _lat = position.latitude;
    _lon = position.longitude;
    notifyListeners();
    loadChange(false);
    return position;
  }
}
