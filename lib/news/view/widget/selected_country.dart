import 'package:aetram_task/news/view/utils/static.dart';
import 'package:flutter/material.dart';

class SelectedCountry {
  SelectedCountry({required this.context});
  final BuildContext context;

  Future<Map<String, dynamic>?> showListOfCountry() async {
    final Map<String, dynamic>? data = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(StaticData.country[index]['country_name'].toString()),
              trailing: Text('(${StaticData.country[index]['country_code']})'),
              onTap: () {
                return Navigator.pop(context, StaticData.country[index]);
              },
            ),
            itemCount: StaticData.country.length,
          ),
        ),
      ),
    );
    return data;
  }
}
