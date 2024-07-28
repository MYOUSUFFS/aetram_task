// ignore_for_file: avoid_print

import 'package:aetram_task/news/controller/provider.dart';
import 'package:aetram_task/setting/provider.dart';
import 'package:aetram_task/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'news/view/news.dart';
import 'news/view/utils/utils.dart';
import 'setting/local.dart';
import 'weather/controller/provider.dart';
import 'weather/view/weather.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
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
  late WeatherProvider weather;
  late ScreenProvider screen;
  late NewsProvider newsProvider;
  bool permissionIs = false;

  @override
  void initState() {
    weather = Provider.of<WeatherProvider>(context, listen: false);
    screen = Provider.of<ScreenProvider>(context, listen: false);
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await startApp();
    });
    super.initState();
  }

  Future startApp() async {
    await _getLocation().then((value) async {
      if (value) {
        await weather.futureWeatherDataFn(context);
        weather.temp = SharedPreferencesService.getTemp();
        newsProvider.category = SharedPreferencesService.getCategory();
        screen.locationStatus = value;
      }
    });
  }

  Future<bool> _getLocation() async {
    var getStatus = await Permission.location.request();
    bool serviceEnabled = await _location();
    bool status = getStatus == PermissionStatus.granted;
    if (status && serviceEnabled) {
      permissionIs = true;
      setState(() {});
      return permissionIs;
    } else {
      permissionIs = false;
      setState(() {});
      return permissionIs;
    }
  }

  Future<bool> _location() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      final open = await Geolocator.openLocationSettings();
      print(open);
      return open;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screen = Provider.of<ScreenProvider>(context);
    weather = Provider.of<WeatherProvider>(context);
    newsProvider = Provider.of<NewsProvider>(context);
    if (permissionIs) {
      switch (screen.screenIndex) {
        case 0:
          return const WeatherHome();
        case 1:
          return const NewsHome();
        case 2:
          return SettingScreen();
        default:
          return const PermissionHandlUi();
      }
    } else {
      return const PermissionHandlUi();
    }
  }
}

class PermissionHandlUi extends StatefulWidget {
  const PermissionHandlUi({super.key});

  @override
  State<PermissionHandlUi> createState() => _PermissionHandlUiState();
}

class _PermissionHandlUiState extends State<PermissionHandlUi> {
  bool loadingTime = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 5), () {
        loadingTime = false;
        if (mounted) {
          setState(() {});
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingTime) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '* Ensure your location is turned on.\n* Please enable location permissions to view the temperature',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Tools.push(context, const NewsHome());
                },
                child: const Text('Without access'))
          ],
        ),
      ),
    );
  }
}
