import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fotune_app/utils/UIData.dart';

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

Widget buildEmptyView() {
  return Container(
    height: 160,
    width: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.network_check,
          size: 50,
          color: UIData.refresh_color,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          "没有更多数据",
          style: TextStyle(fontSize: 16, color: UIData.normal_font_color),
        )
      ],
    ),
  );
}
