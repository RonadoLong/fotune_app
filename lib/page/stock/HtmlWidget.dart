import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class HtmlWidget extends StatefulWidget {
  String url;
  int showIndex = 1;

  HtmlWidget(
    this.url,
    this.showIndex,
  );

  @override
  State createState() {
    return HtmlWidgetState();
  }
}

class HtmlWidgetState extends State<HtmlWidget> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    flutterWebviewPlugin.launch(
      widget.url,
      rect: new Rect.fromLTWH(
          0.0, 200.0, MediaQuery.of(context).size.width, 250.0),
    );
  }
}
