import 'package:flutter/material.dart';

/// 带图标的输入框
class FInputWidget extends StatefulWidget {
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  final bool isNumber;

  FInputWidget(
      {Key key,
      this.hintText,
      this.iconData,
      this.onChanged,
      this.textStyle,
      this.controller,
      this.obscureText = false,
      this.isNumber = false})
      : super(key: key);

  @override
  _FInputWidgetState createState() => new _FInputWidgetState();
}

/// State for [FInputWidget] widgets.
class _FInputWidgetState extends State<FInputWidget> {
  _FInputWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      decoration: new InputDecoration(
        hintText: widget.hintText,
        icon: widget.iconData == null ? null : new Icon(widget.iconData),
      ),
    );
  }
}
