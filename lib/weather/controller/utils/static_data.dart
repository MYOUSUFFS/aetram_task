import 'package:flutter/material.dart';

class WeatherStaticData {
  static const String apiKey = '44892265a6e00da9c6d203d6242b3471';
}

class Tools {
  static void push(BuildContext context, Widget child) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => child));

  static void notify(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
