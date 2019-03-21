import 'package:flutter/material.dart';
import 'package:fotune_app/utils/CommonUtils.dart';

Widget ListBottomWidget(BuildContext context, String title, int time) {
  return Row(
    children: <Widget>[
      DescriptionLabel(context, title),
//      IconText(context, post.commentCount, 'feedComment.png'),
//      IconText(context, post.praiseCount, 'feedPraise.png'),
      Padding(
        padding: EdgeInsets.all(5),
      ),
      DescriptionLabel(context, CommonUtils.getNewsTimeStr(time * 1000)),
    ],
  );
}

Widget TitleLabel(BuildContext context, String text,
    {double fontSize = 15, int maxLines = 3}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Widget DescriptionLabel(BuildContext context, String text,
    {double fontSize = 12, int maxLines = 1}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: Color.fromARGB(200, 100, 100, 100),
    ),
    maxLines: maxLines,
    textAlign: TextAlign.left,
  );
}

Widget IconText(BuildContext context, int text, String ImageStr) {
  return Row(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(2),
      ),
      Image.asset(
        ImageStr,
        fit: BoxFit.fitWidth,
        width: 12,
        height: 12,
      ),
      Padding(
        padding: EdgeInsets.all(1),
      ),
      DescriptionLabel(context, '$text')
    ],
  );
}
