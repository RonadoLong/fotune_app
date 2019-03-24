import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:html/dom.dart' as dom;

class NewsDetailsPage extends StatefulWidget {
  String title, content;
  NewsDetailsPage(this.title, this.content);
  @override
  State<StatefulWidget> createState() =>
      new NewsDetailsPageState(title, content);
}
class NewsDetailsPageState extends State<NewsDetailsPage> {
  String title, content;

  NewsDetailsPageState(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        backgroundColor: UIData.primary_color,
        title: Container(
          margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: Text("详情",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                child: Text(title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                alignment: FractionalOffset.center,
              ),
              Html(
                data: content,
                padding: EdgeInsets.all(8.0),
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag":
                        return Column(children: children);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
