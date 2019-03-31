import 'package:flutter/material.dart';
import 'package:fotune_app/utils/UIData.dart';

class CustomWidget {
  static AppBar BuildAppBar(String title, BuildContext context) {
    return new AppBar(
      title: new Text(title, style: new TextStyle(color: Colors.white)),
      centerTitle: true,
      elevation: 0,
      iconTheme: new IconThemeData(color: Colors.white),
      backgroundColor: UIData.primary_color,
    );
  }

  static Container BuildLogImage(String url) {
    var avatar = url == null
        ? "http://gp.axinmama.com/public/static/home/img/moblie/default-user-img5.png"
        : url;
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: UIData.primary_color,
        image: new DecorationImage(
            image: new NetworkImage(avatar), fit: BoxFit.cover),
        border: new Border.all(
          color: UIData.primary_color,
          width: 2.0,
        ),
      ),
    );
  }
}
