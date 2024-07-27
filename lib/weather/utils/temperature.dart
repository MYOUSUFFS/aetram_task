class Temperature {
  static String convertTemperature(double tempInKelvin, String unit) {
    if (unit.toLowerCase() == 'celsius') {
      return '${double.parse((tempInKelvin - 273.15).toStringAsFixed(2))}°C';
    } else if (unit.toLowerCase() == 'fahrenheit') {
      return '${double.parse(((tempInKelvin - 273.15) * 9 / 5 + 32).toStringAsFixed(2))}°F';
    } else {
      throw Exception(
          'Invalid unit. Please choose either "celsius" or "fahrenheit".');
    }
  }
}
