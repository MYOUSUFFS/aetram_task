import 'package:flutter/material.dart';

import '../news/view/news.dart';
import 'setting.dart';

class ScreenSize {
  static double mobile = 600;
  static double tab = 900;
  static double web = 1200;
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.pagename, this.colors});
  final String pagename;
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Text('Weather & News'),
          ),
          if (pagename != 'News')
            ListTile(
              title: const Text('News'),
              onTap: () {
                push(context, const NewsHome());
              },
            ),
          if (pagename != 'Setting')
            ListTile(
              title: const Text('Setting'),
              onTap: () {
                push(context, SettingScreen());
              },
            ),
        ],
      ),
    );
  }

  push(BuildContext context, Widget child) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => child));
}
