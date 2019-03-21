import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new QuotePageState();
  }
}

class QuotePageState extends State<QuotePage> {
  var title = "行情指数";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '$title',
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('$title'),
        ),
        body: Row(
          children: <Widget>[
            Container(
              color: Colors.red,
              width: 100,
              height: 100,
              margin: EdgeInsets.all(10),
            ),
            Container(
              color: Colors.blue,
              width: 100,
              height: 100,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
