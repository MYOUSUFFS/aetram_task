class WeatherData {
  final Coord coord;
  final List<Weather>? weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;
  final List<Forecast>? forecast;

  WeatherData({
    required this.coord,
    this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
    this.forecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var forecastList = json['list'] as List?;
    List<Forecast>? forecastItems =
        forecastList?.map((i) => Forecast.fromJson(i)).toList();

    return WeatherData(
      coord: Coord.fromJson(json['coord']),
      weather: json['weather'] != null
          ? List<Weather>.from(
              json['weather'].map((item) => Weather.fromJson(item)))
          : null,
      base: json['base'],
      main: Main.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
      forecast: forecastItems,
    );
  }
}

class Forecast {
  final int dt;
  final Main main;
  final List<Weather>? weather;

  Forecast({
    required this.dt,
    required this.main,
    this.weather,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dt: json['dt'],
      main: Main.fromJson(json['main']),
      weather: List<Weather>.from(
          json['weather'].map((item) => Weather.fromJson(item))),
    );
  }
}

class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'],
      feelsLike: json['feels_like'],
      tempMin: json['temp_min'],
      tempMax: json['temp_max'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }
}

class Wind {
  final double speed;
  final int deg;
  final double gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'],
      deg: json['deg'],
      gust: json['gust'],
    );
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}

class Sys {
  final int sunrise;
  final int sunset;

  Sys({required this.sunrise, required this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}
