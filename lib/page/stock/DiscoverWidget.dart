import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/utils/UIData.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

Widget renderHtml(String _webUrl) {
  return Container(
    color: Colors.white,
    height: 250,
    child: new WebviewScaffold(
      url: _webUrl, // 登录的URL
      withZoom: false,
      withLocalStorage: true, // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
      userAgent: kAndroidUserAgent,
    ),
  );
}

Widget buildContent(
    String title,
    String code,
    String name,
    int price,
    int amount,
    UserInfo user,
    int stockCount,
    double liyonngCount,
    TextEditingController cr,
    List<Widget> checkList,
    List<Widget> beiList,
    Function showProtocol) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: ShapeDecoration(
          color: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "信用金: ",
                style: TextStyle(color: UIData.normal_font_color, fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
              ),
              Container(
                width: 120,
                child: TextField(
                  enabled: true,
                  controller: cr,
                  decoration: InputDecoration(
                    hintText: price == 0 ? '请输入信用金' : '$price',
                    border: UnderlineInputBorder(),
                    hintStyle: TextStyle(
                        color: UIData.normal_font_color, fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
              ),
              Text(
                "元",
                style: TextStyle(color: UIData.primary_color),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          SizedBox(
            child: Wrap(
              spacing: 6.0, // gap between adjacent chips
              runSpacing: 2.0, // gap between lines
              children: checkList,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceEvenly,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          SizedBox(
            child: Wrap(
              spacing: 2.0, // gap between adjacent chips
              runSpacing: 2.0,
              children: beiList,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                  "可买入",
                  style: TextStyle(fontSize: 12),
                ),
                Text(" $stockCount ",
                    style:
                        TextStyle(color: UIData.primary_color, fontSize: 12)),
                Text("股，资金利用率 ", style: TextStyle(fontSize: 12)),
                Text("$liyonngCount %",
                    style:
                        TextStyle(color: UIData.primary_color, fontSize: 12)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          Container(
            // margin: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text("信用金",
                      style: TextStyle(
                          color: UIData.normal_font_color, fontSize: 13)),
                ),
                Text("$price",
                    style:
                        TextStyle(color: UIData.primary_color, fontSize: 13)),
                Text("元",
                    style: TextStyle(
                        color: UIData.normal_font_color, fontSize: 13))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          Container(
            // margin: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text("操盘资金",
                      style: TextStyle(
                          color: UIData.normal_font_color, fontSize: 13)),
                ),
                Text("$amount",
                    style:
                        TextStyle(color: UIData.primary_color, fontSize: 13)),
                Text("元",
                    style: TextStyle(
                        color: UIData.normal_font_color, fontSize: 13))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 2),
            height: 1,
            color: Colors.black38,
          ),
          Text(
            "交易时间段：09:30-11:30 | 13:00-14:58",
            style: TextStyle(color: Colors.redAccent, fontSize: 14),
          ),//点买时间9:30-11:30, 13:00-14:58
        //点买时间9:30-11:30, 13:00-14:58
          GestureDetector(
            onTap: (){
              showProtocol(1);
            },
            child: Container(
              margin: EdgeInsets.only(top: 12),
              child: Text("《策略人参与沪深A股交易合作涉及费用及资费标准》",
                  style:
                  TextStyle(color: Colors.cyan, fontSize: 12)),
            ),
          ),
          GestureDetector(
            onTap: (){
              showProtocol(2);
            },
            child: Container(
              margin: EdgeInsets.only(top: 12),
              child: Text("《富通投资人与点买人参与沪深A股交易合作协议》",
                  style:
                  TextStyle(color: Colors.cyan, fontSize: 12)),
            ),
          ),
          GestureDetector(
            onTap: (){
              showProtocol(3);
            },
            child: Container(
              margin: EdgeInsets.only(top: 12),
              child: Text("《富通服务协议》",
                  style:
                  TextStyle(color: Colors.cyan, fontSize: 12)),
            ),
          ),
          Container(
            child: RadioListTile<String>(
              value: '我已阅并签署以下协议',
              title: Text('我已阅并签署以上协议',
                  style:
                      TextStyle(color: UIData.normal_font_color, fontSize: 13)),
              onChanged: (value) {},
              groupValue: '我已阅并签署以下协议',
            ),
          ),
        ],
      ),
    ),
  );
}

Container renderHeader(String codeName, String code, var amount) {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Container(
        //   child: Text(
        //     codeName,
        //     style: TextStyle(
        //         color: UIData.grey_color,
        //         fontSize: 16.0,
        //         fontWeight: FontWeight.w500),
        //   ),
        // ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
               Text(
                "$amount 元",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
