import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadMore extends StatelessWidget {
  ///上拉加载更多
  Widget _buildProgressIndicator() {
    ///是否需要显示上拉加载更多的loading
    Widget bottomWidget =
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      ///loading框
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildProgressIndicator();
  }
}
