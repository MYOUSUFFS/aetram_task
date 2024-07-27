import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'news/view/news.dart';
import 'weather/controller/weather.dart';
import 'weather/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final bool which = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        title: 'Weather & News',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: which ? const WeatherHome() : const NewsHome(),
      ),
    );
  }
}
