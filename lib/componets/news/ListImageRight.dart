import 'package:cached_network_image/cached_network_image.dart';
import 'package:fotune_app/model/news_enity.dart';

import 'BaseModuleWidget.dart';
import 'package:flutter/material.dart';

Widget ListImageRight(BuildContext context, Data data) {
  Widget widget;
  widget = new Row(
    children: <Widget>[
      Container(
        width: 200,
        height: 120,
        margin: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Container(
              child: TitleLabel(context, data.articleTitle),
              height: 90,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  alignment: Alignment.bottomLeft,
                  child:
                      ListBottomWidget(context, data.articleAuthor, data.time)),
            )
          ],
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.black12,
          margin: EdgeInsets.only(left: 0, right: 10, top: 6, bottom: 4),
//              width: 170,
          height: 120,
          child:
              // Image.network(
              //   data.articleThumbnail,
              //   fit: BoxFit.fitHeight,
              // ),
              getImage(data.articleThumbnail),
        ),
      ),
    ],
  );
  return widget;
}

getImage(String imgUrl) {
  return new CachedNetworkImage(
    imageUrl: imgUrl,
    errorWidget: new Icon(Icons.error),
    fit: BoxFit.cover,
    height: 85.0,
    width: 110.0,
  );
}
