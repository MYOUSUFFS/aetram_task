import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/location_permission.dart';

class WeatherProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  loadChange(bool loadIs) {
    _isLoading = loadIs;
    notifyListeners();
  }

  double _lat = 0.0;
  double get lat => _lat;

  double _lon = 0.0;
  double get lon => _lon;

  void setLatLog() async {
    loadChange(true);
    Position position = await PositionIs().getCurrentLocation();
    _lat = position.latitude;
    _lon = position.longitude;
    notifyListeners();
    loadChange(false);
  }
}
