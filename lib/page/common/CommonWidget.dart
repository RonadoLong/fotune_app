import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///上拉加载更多
Widget BuildLoadMoreView() {
  Widget bottomWidget =
      new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    new SpinKitThreeBounce(color: Color(0xFF24292E)),
    new Container(
      width: 5.0,
    ),
  ]);
  return new Padding(
    padding: const EdgeInsets.all(20.0),
    child: new Center(
      child: bottomWidget,
    ),
  );
}
