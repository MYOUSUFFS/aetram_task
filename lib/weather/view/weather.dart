import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/api.dart';
import '../controller/weather.dart';
import 'weather_screen.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherProvider weather;
  @override
  void initState() {
    weather = Provider.of<WeatherProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getApiCall();
    });
    super.initState();
  }

  Future<void> getApiCall() async {
    await WeatherApi().weatherApi(context);
  }

  @override
  Widget build(BuildContext context) {
    weather = Provider.of<WeatherProvider>(context);
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
