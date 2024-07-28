import 'package:aetram_task/drawer.dart';
import 'package:aetram_task/weather/controller/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final List temp = ['celsius', 'fahrenheit'];

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(pagename: 'Setting'),
      body: Container(
        constraints: BoxConstraints(minWidth: ScreenSize.mobile),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Scale : '),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
