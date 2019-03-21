import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fotune_app/page/stock/StockSearchPage.dart';
import 'package:fotune_app/page/login/LoginPage.dart';
import 'package:fotune_app/page/login/RegisterPage.dart';
import 'package:fotune_app/componets/news/NewsWebPage.dart';

GotoWebPage(String h5_url, BuildContext context) {
  Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new NewsWebPage(h5_url, '我的开源')));
}

Future GotoLoginPage(BuildContext context) async {
  var res = await Navigator.push(
      context, new MaterialPageRoute(builder: (context) => new LoginPage()));
  print(res);
  return res;
}

GotoRegisterPage(BuildContext context) {
  Navigator.push(
      context, new MaterialPageRoute(builder: (context) => new RegisterPage()));
}

GotoSearchPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => StockSearchPage()));
}
