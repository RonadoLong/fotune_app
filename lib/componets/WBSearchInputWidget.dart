import 'package:flutter/material.dart';
import 'package:fotune_app/utils/UIData.dart';

class WBSearchInputWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  final VoidCallback onSubmitPressed;

  WBSearchInputWidget(this.onChanged, this.onSubmitted, this.onSubmitPressed);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: Colors.white,
          border: new Border.all(color: UIData.primary_color, width: 0.3),
          boxShadow: [BoxShadow(color: UIData.grey_color, blurRadius: 4.0)]),
      padding:
          new EdgeInsets.only(left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                  autofocus: false,
                  decoration: new InputDecoration.collapsed(
                    hintText: "输入代码/名称查询更多",
                    hintStyle: TextStyle(
                        fontSize: 15, color: UIData.normal_font_color),
                  ),
                  style:
                      TextStyle(fontSize: 15, color: UIData.normal_font_color),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted)),
          new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.only(right: 5.0, left: 10.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new Icon(
                Icons.search,
                color: UIData.normal_font_color,
              ),
              onPressed: onSubmitPressed)
        ],
      ),
    );
  }
}
