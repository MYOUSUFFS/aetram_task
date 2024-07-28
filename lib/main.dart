import 'package:aetram_task/news/controller/provider.dart';
import 'package:aetram_task/provider.dart';
import 'package:aetram_task/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'news/view/news.dart';
import 'weather/controller/provider.dart';
import 'weather/view/weather.dart';

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
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => NewsTempProvider())
      ],
      child: MaterialApp(
        title: 'Weather & News',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const Screen(),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<WeatherProvider>(context, listen: false)
          .futureWeatherDataFn(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Provider.of<ScreenProvider>(context);
    switch (screen.screenIndex) {
      case 0:
        return const WeatherHome();
      case 1:
        return const NewsHome();
      case 2:
        return SettingScreen();
      default:
        return const WeatherHome();
    }
  }
}
