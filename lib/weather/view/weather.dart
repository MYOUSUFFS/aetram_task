import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../setting/drawer.dart';
import '../../news/view/news.dart';
import '../controller/api.dart';
import '../controller/provider.dart';
import '../controller/utils/static_data.dart';
import '../model/weather.dart';
import '../controller/utils/temperature.dart';

class WeatherHome extends StatelessWidget {
  const WeatherHome({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          const SafeArea(child: Center(child: WeatherScreen())),
          if (weather.isLoading) ...[
            const Center(child: CircularProgressIndicator()),
          ]
        ],
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherProvider weather;
  WeatherData? futureWeatherData;

  @override
  void initState() {
    super.initState();
    weather = Provider.of<WeatherProvider>(context, listen: false);
  }

  String? newsHead;
  @override
  Widget build(BuildContext context) {
    weather = Provider.of<WeatherProvider>(context);
    futureWeatherData = weather.futureWeatherData;
    if (weather.currentTemp != null) {
      newsHead = Temperature.tempNews(weather.currentTemp!);
    } else {
      newsHead = Temperature.tempNews(30);
    }
    return LayoutBuilder(
      builder: (context, sizeIs) {
        return Scaffold(
          drawer: sizeIs.maxWidth < ScreenSize.web
              ? const AppDrawer(pagename: 'Weather')
              : null,
          appBar: sizeIs.maxWidth < ScreenSize.web
              ? AppBar(
                  title: Text(
                    'Weather App',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.deepPurple,
                  elevation: 0,
                  actions: [
                    if (sizeIs.maxWidth < ScreenSize.tab)
                      IconButton(
                        icon: const Icon(Icons.newspaper),
                        onPressed: () {
                          Tools.push(
                            context,
                            Scaffold(
                              appBar: AppBar(
                                title: const Text('Temperature News'),
                                centerTitle: true,
                                actions: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(newsHead.toString()),
                                  )
                                ],
                              ),
                              body: Align(
                                alignment: Alignment.center,
                                child:
                                    NewsList(temperature: true, news: newsHead),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                )
              : null,
          body: Row(
            children: [
              if (sizeIs.maxWidth > ScreenSize.web)
                const AppDrawer(
                  pagename: 'Weather',
                  colors: Colors.deepPurple,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (sizeIs.maxWidth > ScreenSize.tab) ...[
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.deepPurple,
                        width: double.infinity,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Weather App',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.blueAccent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: (futureWeatherData != null)
                              ? buildWeatherInfo(futureWeatherData!)
                              : const Text('Loading...'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (sizeIs.maxWidth > ScreenSize.tab) ...[
                Expanded(
                    child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          'Temperature News',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        if (newsHead != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$newsHead'),
                            ),
                          )
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: NewsList(temperature: true, news: newsHead),
                    ),
                  ],
                ))
              ]
            ],
          ),
        );
      },
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
              data.name,
              style: GoogleFonts.lato(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              Temperature.convertTemperature(data.main.temp, weather.temp),
              style: GoogleFonts.lato(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            Text(
              'Feels Like: ${Temperature.convertTemperature(data.main.feelsLike, weather.temp)}',
              style: GoogleFonts.lato(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildInfoItem('Humidity', '${data.main.humidity}%'),
                buildInfoItem('Pressure', '${data.main.pressure} hPa'),
                buildInfoItem('Wind Speed', '${data.wind.speed} m/s'),
              ],
            ),
            const SizedBox(height: 32),
            const ForecastList()
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
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}

class ForecastList extends StatefulWidget {
  const ForecastList({super.key});

  @override
  State<ForecastList> createState() => _ForecastListState();
}

class _ForecastListState extends State<ForecastList> {
  late WeatherProvider weather;
  late Future<List<Forecast>?> forecast;

  @override
  void initState() {
    weather = Provider.of<WeatherProvider>(context, listen: false);
    forecast = WeatherApi().fetchForecastData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    weather = Provider.of<WeatherProvider>(context);

    return FutureBuilder(
        future: forecast,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                buildForecast(snapshot.data!),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return buildForecastItem(snapshot.data![index]);
                    },
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildForecast(List<Forecast> forecast) {
    return Column(
      children: <Widget>[
        Text(
          '5-Day Forecast',
          style: GoogleFonts.lato(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildForecastItem(Forecast forecast) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000);
    String day = DateFormat('EEEE').format(date);
    String time = DateFormat('HH:mm').format(date);

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$day\n$time',
            style: GoogleFonts.lato(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.weather?[0].icon}@2x.png',
            scale: 1.0,
          ),
          const SizedBox(height: 8),
          Text(
            Temperature.convertTemperature(forecast.main.temp, weather.temp),
            style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
