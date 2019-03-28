import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';

class NewPeoplePage extends StatefulWidget {
  String url;
  NewPeoplePage(String url) {
    this.url = url;
  }

  @override
  State<StatefulWidget> createState() {
    return NewPeoplePageState();
  }
}

class NewPeoplePageState extends State<NewPeoplePage> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: CustomWidget.BuildAppBar("新手指引", context),
      url: widget.url,
    );
  }

}