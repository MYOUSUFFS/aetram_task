import 'package:flutter/material.dart';

class Tools {
  static void push(BuildContext context, Widget child) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => child));

  static void notify(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
