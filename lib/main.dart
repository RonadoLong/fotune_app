// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:fotune_app/MainPage.dart';
import 'package:fotune_app/page/notfound/notfound_page.dart';
import 'package:fotune_app/utils/UIData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final materialApp = MaterialApp(
      title: UIData.appName,
      theme: new ThemeData(
        primaryColor: UIData.primary_color,
      ),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: MainPage(),
      onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
          builder: (context) => new NotFoundPage(
                appTitle: UIData.coming_soon,
                icon: Icons.network_wifi,
                title: UIData.coming_soon,
                message: "联系客服",
                iconColor: Colors.green,
              )));

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
