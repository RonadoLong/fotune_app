import 'package:flutter/material.dart';

class SyCell extends StatelessWidget {
  final Widget icon;
  final String title;
  final String endText;
  final VoidCallback onTap;

  SyCell({
    @required this.title,
    this.icon,
    this.onTap,
    this.endText: '',
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding:
            EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: theme.dividerColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: icon,
                  )
                : Container(),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
              ),
            ),
            Text(endText),
            onTap == null
                ? Container()
                : Icon(
                    Icons.navigate_next,
                    color: theme.disabledColor,
                  )
          ],
        ),
      ),
    );
  }
}
