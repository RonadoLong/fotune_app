import 'package:flutter/material.dart';
import 'package:fotune_app/model/ListEnity.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/utils/UIData.dart';

// ignore: must_be_immutable
class CreateDialog extends Dialog {
  var title;
  ListEnity enity;
  BuildContext context;
  Function onBoyChooseEvent;
  Function onGirlChooseEvent;

  CreateDialog({
    Key key,
    @required this.title,
    @required ListEnity enity,
    @required BuildContext context,
    @required this.onBoyChooseEvent,
    @required this.onGirlChooseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("=============================");
    Stock stock = enity == null ? null : enity.data;
    print(stock);
    String code = stock == null ? "" : stock.stock_code2;
    return new StatefulBuilder(builder: (context, StateSetter setState) {
      return enity == null
          ? CircularProgressIndicator()
          : new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Material(
                  type: MaterialType.transparency,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 20.0, 10.0, 10.0),
                              child: Center(
                                  child: new Text(title,
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                      )))),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 1,
                            color: UIData.primary_color,
                          ),
                          renderHeader(code, 111.11),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.all(7.0),
                                      labelText: '请输入信用金',
                                      labelStyle: TextStyle(
                                          color: UIData.normal_font_color,
                                          fontSize: 12)),
                                  onChanged: (res) {
                                    print(res);
                                  },
                                  autofocus: false,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4),
                              ),
                              Text(
                                "元",
                                style:
                                    TextStyle(color: UIData.normal_font_color),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Container(
                              child: new CheckboxListTile(
                                  title: new Text("选项"),
                                  value: selected,
                                  onChanged: (bool) {
                                    onBoyChooseEvent();
                                  })),
                        ],
                      ),
                    ),
                  )),
            );
    });
  }

  List<bool> isCheck = [false, false, false, false];
  bool selected = false;

  List<Widget> buildSelect() {
    List<Widget> wlist = new List();

    for (int i = 0; i < isCheck.length; i++) {
      bool vul = isCheck[i];
      wlist.add(Container(
          child: new CheckboxListTile(
              title: new Text("选项"),
              value: selected,
              onChanged: (bool) {
                onBoyChooseEvent();
              })));
    }

    return wlist;
  }

  Widget _genderChooseItemWid(var gender) {
    return GestureDetector(
        onTap: gender == 1 ? this.onBoyChooseEvent : this.onGirlChooseEvent,
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 40.0),
              child: Text(gender == 1 ? '我是男生' : '我是女生',
                  style: TextStyle(
                      color: Color(gender == 1 ? 0xff4285f4 : 0xffff4444),
                      fontSize: 15.0)))
        ]));
  }

  Container renderHeader(String codeName, double amount) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              codeName,
              style: TextStyle(
                  color: UIData.grey_color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "代号: $codeName",
                  style: TextStyle(
                      color: UIData.primary_color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "账户资金: $amount",
                  style: TextStyle(
                      color: UIData.primary_color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
