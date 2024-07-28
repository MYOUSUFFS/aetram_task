import 'package:aetram_task/news/controller/provider.dart';
import 'package:aetram_task/setting/local.dart';
import 'package:aetram_task/weather/controller/utils/temperature.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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
    if (_futureWeatherData == null) {
      final newsTemp = Provider.of<NewsTempProvider>(context, listen: false);
      loadChange(true);
      WeatherData? value = await WeatherApi().fetchWeatherData(context);
      _futureWeatherData = value;
      _currentTemp = value.main.temp;
      final modeOf = Temperature.tempNews(_currentTemp!);
      newsTemp.hotNews(modeOf);
      loadChange(false);
      notifyListeners();
    }
  }

  double? _currentTemp;
  double? get currentTemp => _currentTemp;

  String _temp = 'celsius';
  String get temp => _temp;

  set temp(String? value) {
    _temp = value ?? _temp;
    notifyListeners();
  }

  tempFn(String value) async {
    await SharedPreferencesService.setTemp(value);
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
