import 'package:flutter/material.dart';
import 'package:fotune_app/utils/UIData.dart';

class SelectedWidget extends StatefulWidget {
  final ValueChanged<int> tapCall;

  SelectedWidget(this.tapCall);

  @override
  State<StatefulWidget> createState() {
    return SelectedWidgetState();
  }
}

class SelectedWidgetState extends State<SelectedWidget> {
  Color colorRed = UIData.primary_color;
  Color colorGrey = UIData.grey_color;

  @override
  Widget build(BuildContext context) {
    return renderSelected();
  }

  _changeColor(int index) {
    widget.tapCall(index);
    setState(() {
      colorGrey = index == 1 ? UIData.grey_color : UIData.primary_color;
      colorRed = index == 1 ? UIData.primary_color : UIData.grey_color;
    });
  }

  Widget renderSelected() {
    return new Container(
      margin: EdgeInsets.all(10.0),
      width: 300,
      height: 30,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _changeColor(1);
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
              child: Text(
                "分时",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _changeColor(2);
              });
            },
            child: Container(
              width: 150,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorGrey,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    topRight: Radius.circular(4)),
              ),
              child: Text(
                "日K",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
