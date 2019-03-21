import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/ListEnity.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/stock/DiscoverWidget.dart';
import 'package:fotune_app/page/stock/SelectedWidget.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';

import 'package:fotune_app/utils/Compute.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

class SellAndBuy {
  String label;
  var price;
  var num;

  SellAndBuy(this.label, this.price, this.num);
}

class StockDetailsPage extends StatefulWidget {
  ListEnity enity;

  StockDetailsPage(this.enity);

  @override
  State<StatefulWidget> createState() => new StockDetailsPageState(enity);
}

class StockDetailsPageState extends State<StockDetailsPage>
    with SingleTickerProviderStateMixin {
  ListEnity enity;
  List StockComments = [];
  List<SellAndBuy> sellList = [];
  List<SellAndBuy> buyList = [];

  double traded_num,
      traded_amount,
      gains,
      yesterday_close,
      current_prices,
      today_open;
  String type, stock_code2, stock_code, stock_name;
  
  String url = "http://192.168.3.176:9527/marker/mindex.html";
  int index = 1;
  UserInfo userInfo;

  StockDetailsPageState(this.enity);

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
  }

  @override
  void deactivate() {
    super.deactivate();
    flutterWebviewPlugin.close();
  }

  @override
  void initState() {
    super.initState();
    type = enity.type;
    initData();
  }

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.launch(
      url,
      rect: new Rect.fromLTWH(
          0.0, 210.0, MediaQuery.of(context).size.width, 250.0),
    );

    Widget body = userInfo == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : new RefreshIndicator(
            child: mainWidget(),
            onRefresh: pullToRefresh,
          );

    return Scaffold(
      body: body,
    );
  }

  void initData() {
    if ("stock" == type) {
      Stock stock = enity.data;
      stock_name = stock.name;
      stock_code = stock.stock_code;
      stock_code2 = stock.stock_code2;
      traded_num = double.parse(stock.traded_num);
      traded_amount = double.parse(stock.traded_amount);
      gains = stock.gains;

      yesterday_close = double.parse(stock.yesterday_close);
      current_prices = double.parse(stock.current_prices);
      today_open = double.parse(stock.today_open);

      sellList.add(SellAndBuy("卖5", stock.sell5, stock.sell5_apply_num));
      sellList.add(SellAndBuy("卖4", stock.sell4, stock.sell4_apply_num));
      sellList.add(SellAndBuy("卖3", stock.sell3, stock.sell3_apply_num));
      sellList.add(SellAndBuy("卖2", stock.sell2, stock.sell2_apply_num));
      sellList.add(SellAndBuy("卖1", stock.sell1, stock.sell1_apply_num));
      buyList.add(SellAndBuy("买1", stock.buy1, stock.buy1_apply_num));
      buyList.add(SellAndBuy("买2", stock.buy2, stock.buy2_apply_num));
      buyList.add(SellAndBuy("买3", stock.buy3, stock.buy3_apply_num));
      buyList.add(SellAndBuy("买4", stock.buy4, stock.buy4_apply_num));
      buyList.add(SellAndBuy("卖5", stock.buy5, stock.buy5_apply_num));
    } else {
      StockIndex stockIndex = enity.data;
      stock_name = stockIndex.name;
      stock_code = stockIndex.stock_code;
      stock_code2 = stockIndex.stock_code2;
    }

    User user = GetLocalUser();
    if (user == null) {
    } else {
      GetUserInfo(user.user_id).then((res) {
        if (res.code == 1000) {
          setState(() {
            userInfo = res.data;
          });
        }
      });
    }
  }

  mainWidget() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          flexibleSpace: buildAppBar(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return new Column(
                children: ShowMainWidget(),
              );
            },
            childCount: 1,
          ),
        )
      ],
    );
  }

  ShowMainWidget() {
    if ("stock" == type) {
      return <Widget>[TopMarket(), getKline(), getSellAndBuy(), buildBottom()];
    } else {
      return <Widget>[getKline()];
    }
  }

  Widget buildBottom() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      child: RaisedButton(
        onPressed: () {
          flutterWebviewPlugin.hide();
          showMyDialogWithStateBuilder(context, enity.data, userInfo);
        },
        color: UIData.primary_color,
        child: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            "添加策略",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      brightness: Brightness.light,
      backgroundColor: UIData.primary_color,
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(stock_name,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text(stock_code,
                style: new TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.white)),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget getKline() {
    return SelectedWidget(
      (i) {
        setState(() {
          index = i;
          url = i == 1
              ? "http://192.168.3.176:9527/marker/mindex.html"
              : "http://192.168.3.176:9527/marker/dindex.html";
        });
      },
    );
  }

  Widget getSellAndBuy() {
    return Container(
        margin: EdgeInsets.only(top: 270),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buildSellAndBuy(),
            ),
            Padding(
              padding: EdgeInsets.all(3),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buildBuy(),
            ),
          ],
        ));
  }

  List<Widget> buildSellAndBuy() {
    List<Widget> widgetList = new List();
    for (SellAndBuy sell in sellList) {
      widgetList.add(getSellAndBuyWidget(sell));
    }
    return widgetList;
  }

  List<Widget> buildBuy() {
    List<Widget> widgetList = new List();
    for (SellAndBuy sell in buyList) {
      widgetList.add(getSellAndBuyWidget(sell));
    }
    return widgetList;
  }

  getSellAndBuyWidget(SellAndBuy sell) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            sell.label,
            style: TextStyle(fontSize: 12),
          ),
          Text(
            sell.price,
            style: TextStyle(fontSize: 12, color: UIData.primary_color),
          ),
          Text(
            sell.num,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /**
   * 顶部行情部分
   */
  // ignore: non_constant_identifier_names
  Widget TopMarket() {
    return new Container(
      margin: new EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      height: 50.0,
      child: Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              child: ShowPrices(),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "今    开",
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              today_open.toStringAsFixed(2),
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            alignment: FractionalOffset.centerRight,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "成交量",
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              (traded_num / 1000000).toStringAsFixed(2) + "万手",
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            alignment: FractionalOffset.centerRight,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new Column(children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "昨    收",
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.black38),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            yesterday_close.toStringAsFixed(2),
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "成交额",
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.black38),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            (traded_amount ~/ 10000).toString() + "万",
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  flex: 1,
                )
              ]),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List isCheck = [false, false, false, false];

  List<int> _sub = <int>[
    100,
    1000,
    5000,
    10000,
    20000,
    30000,
    40000,
    50000,
  ];

  List<int> beishuList = <int>[5, 6, 7, 8];

  Iterable<Widget> get actorWidgets sync* {}
  int _selected = 100;
  int _selectedBei = 5;

  //显示对话框 添加策略
  void showMyDialogWithStateBuilder(
      BuildContext context, Stock stock, UserInfo userInfo) {
    String code = stock == null ? "" : stock.stock_code2;
    String name = stock == null ? "" : stock.name;
    double wWidth = MediaQuery.of(context).size.width - 30;
    double hh = MediaQuery.of(context).size.height - 60;
    int amount = 0;
    int stockCount = 0;

    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              List<Widget> widgetList = new List();
              for (int choiceSub in _sub) {
                widgetList.add(ChoiceChip(
                  backgroundColor: Colors.red,
                  disabledColor: Colors.blue,
                  label: Text(
                    '$choiceSub',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                  ),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                  labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onSelected: (bool value) {
                    setState(() {
                      _selected = choiceSub;
                    });
                  },
                  selected: _selected == choiceSub,
                ));
              }

              List<Widget> beishuListW = new List();
              widgetList.add(Text(
                "策略倍数: ",
                style: TextStyle(fontSize: 14),
              ));
              for (int choiceSub in beishuList) {
                widgetList.add(ChoiceChip(
                  backgroundColor: Colors.red,
                  disabledColor: Colors.blue,
                  label: Text('$choiceSub'),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
                  labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onSelected: (bool value) {
                    setState(() {
                      _selectedBei = value ? choiceSub : value;
                    });
                  },
                  selected: _selectedBei == choiceSub,
                ));
              }

              var priceController =
                  new TextEditingController(text: '$_selected');
              amount = _selected * _selectedBei;

              // 操盘资金 / 限价 = 股数
              double count = amount.ceilToDouble() /
                  double.parse(stock.current_prices) /
                  100;

              if (count >= 1) {
                stockCount = count.toInt() * 100;
              } else {
                stockCount = 0;
              }
              String liyong = (stockCount *
                      double.parse(stock.current_prices) /
                      amount *
                      100)
                  .toStringAsFixed(2);
              double liyonngCount = double.parse(liyong);

              return Container(
                width: wWidth,
                height: hh,
                child: buildContent(
                    "添加策略",
                    code,
                    name,
                    _selected,
                    amount,
                    stockCount,
                    liyonngCount,
                    priceController,
                    widgetList,
                    beishuListW),
              );
            }),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "取消",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black26,
                onPressed: () {
                  Navigator.of(context).pop();
                  flutterWebviewPlugin.show();
                },
              ),
              new FlatButton(
                child: new Text("提交", style: TextStyle(color: Colors.white)),
                color: UIData.primary_color,
                onPressed: () {
                  if (stockCount == 0) {
                    ShowToast("股数不能为零");
                    return;
                  }

                  if (userInfo.amount == 0) {
                    ShowToast("您的账户余额不足请前往充值");
                    return;
                  }
                  var addStrategyReq = {
                    "uid": userInfo.id,
                    "stockCode": stock.stock_code,
                    "stockName": stock.name,
                    "multiple": _selectedBei,
                    "stockCount": stockCount,
                  };
                  print(addStrategyReq);
                  AddStrategy(addStrategyReq).then((res) {
                    if (res.code == 1000) {
                      ShowToast("添加成功");
                    } else {
                      ShowToast("添加失败");
                    }
                    Navigator.of(context).pop();
                  }).then((res) {
                    ShowToast("网络出错");
                  });
                },
              ),
            ],
          );
        });
  }

  Future<Null> pullToRefresh() async {
    getDatas(2);
    return null;
  }

  void getDatas(int request_type) {
    if ("stock" == type) {
      String url = "http://hq.sinajs.cn/list=" + stock_code2;
      fetch(url).then((data) {
        setState(() {
          List<String> stockstrs = data.split(";");
          setState(() {
            String str = stockstrs[0];
            Stock stock = new Stock();
            stock = DealStocks(str, stock);
            traded_num = double.parse(stock.traded_num);
            traded_amount = double.parse(stock.traded_amount);
            gains =
                ComputeGainsRate(yesterday_close, current_prices, today_open);

            yesterday_close = double.parse(stock.yesterday_close);
            current_prices = double.parse(stock.current_prices);
            today_open = double.parse(stock.today_open);
          });
          if (request_type == 2) {
            Fluttertoast.showToast(
                msg: "刷新成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.red);
          }
        });
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: "网络异常，请检查",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.red);
      });
    }
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  /**
   * 主要价格信息
   */
  ShowPrices() {
    Color show_color;
    String gains_num =
        ComputeGainsNum(yesterday_close, current_prices, today_open);
    String gains_str = (gains * 100).toStringAsFixed(2) + "%";
    if (gains > 0) {
      show_color = Colors.red;
      gains_str = "+" + gains_str;
      gains_num = "+" + gains_num;
    } else if (gains < 0) {
      show_color = Colors.green;
    } else {
      show_color = Colors.black38;
    }
    return new Container(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              current_prices.toStringAsFixed(2),
              style: new TextStyle(fontSize: 24.0, color: show_color),
            ),
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
            alignment: FractionalOffset.topLeft,
          ),
          new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    gains_num,
                    style: new TextStyle(fontSize: 12.0, color: show_color),
                    textAlign: TextAlign.left,
                  ),
                  alignment: FractionalOffset.bottomLeft,
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    gains_str,
                    style: new TextStyle(fontSize: 12.0, color: show_color),
                    textAlign: TextAlign.left,
                  ),
                  alignment: FractionalOffset.bottomLeft,
                ),
                flex: 1,
              )
            ],
          )
        ],
      ),
    );
  }
}
