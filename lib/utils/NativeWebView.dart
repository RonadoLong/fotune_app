import 'package:flutter/material.dart';
//import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
//
//class NativeWebView extends StatelessWidget {
//  String webUrl;
//  final Rect webRect;
//  InAppWebViewController webView;
//
//  NativeWebView({Key key, this.webUrl, this.webRect}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    InAppWebView webWidget = new InAppWebView(
//        initialUrl: webUrl,
//        initialHeaders: {},
//        initialOptions: {},
//        onWebViewCreated: (InAppWebViewController controller) {
//          webView = controller;
//        },
//        onLoadStart: (InAppWebViewController controller, String url) {
//          print("started -------------- $url");
//          this.webUrl = url;
//        },
//        onProgressChanged: (InAppWebViewController controller, int progress) {
//          double prog = progress / 100;
//          print('prog --------- $prog');
//        });
//
//    return Container(
//      width: webRect.width,
//      height: webRect.height,
//      child: webWidget,
//    );
//  }
//}
