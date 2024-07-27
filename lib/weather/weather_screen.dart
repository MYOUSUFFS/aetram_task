// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'controller/api.dart';
import 'model/weather.dart';
import 'utils/temperature.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherData> futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureWeatherData = WeatherApi().fetchWeatherData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FutureBuilder<WeatherData>(
            future: futureWeatherData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildWeatherInfo(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}',
                    style: GoogleFonts.lato(color: Colors.white));
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildWeatherInfo(WeatherData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${data.name}',
              style: GoogleFonts.lato(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              Temperature.convertTemperature(data.main.temp, 'celsius'),
              style: GoogleFonts.lato(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            Text(
              'Feels Like: ${Temperature.convertTemperature(data.main.feelsLike, 'celsius')}',
              style: GoogleFonts.lato(fontSize: 24, color: Colors.white70),
            ),
            SizedBox(height: 16),
            Image.network(
              'https://openweathermap.org/img/wn/${data.weather?[0].icon}@2x.png',
              scale: 0.6,
            ),
            Text(
              '${data.weather?[0].main}',
              style: GoogleFonts.lato(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '${data.weather?[0].description}',
              style: GoogleFonts.lato(fontSize: 24, color: Colors.white70),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildInfoItem('Humidity', '${data.main.humidity}%'),
                buildInfoItem('Pressure', '${data.main.pressure} hPa'),
                buildInfoItem('Wind Speed', '${data.wind.speed} m/s'),
              ],
            ),
            SizedBox(height: 32),
            if (data.forecast != null) ...[
              buildForecast(data.forecast!),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildInfoItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.lato(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildForecast(List<Forecast> forecast) {
    return Column(
      children: <Widget>[
        Text(
          '5-Day Forecast',
          style: GoogleFonts.lato(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              return buildForecastItem(forecast[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildForecastItem(Forecast forecast) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000);
    String day = DateFormat('EEEE').format(date);

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            day,
            style: GoogleFonts.lato(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.weather?[0].icon}@2x.png',
            scale: 1.0,
          ),
          SizedBox(height: 8),
          Text(
            '${forecast.main.temp}°C',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
