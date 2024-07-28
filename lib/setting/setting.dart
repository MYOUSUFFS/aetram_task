import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../news/controller/provider.dart';
import '../news/view/utils/static.dart';
import 'drawer.dart';
import '../weather/controller/provider.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final List temp = ['celsius', 'fahrenheit'];

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherProvider>(context);
    final news = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: ScreenSize.mobile,
          constraints: BoxConstraints(minWidth: ScreenSize.mobile),
          child: Column(
            children: [
              const Row(
                children: [
                  Text('Temperature Unit:'),
                  SizedBox(width: 10),
                  Flexible(child: Divider())
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  value: weather.temp,
                  items: temp
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    weather.tempFn(value.toString());
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text('News category:'),
                  SizedBox(width: 10),
                  Flexible(child: Divider())
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  value: (news.category == null || news.category == 'all')
                      ? 'all'
                      : news.category,
                  items: StaticData.category
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    news.changeCategory(value.toString());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
