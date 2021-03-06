import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/ListEnity.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/stock/AddStrategyPage.dart';

import 'package:fotune_app/page/stock/SelectedWidget.dart';
import 'package:fotune_app/page/stock/model/Setting.dart';
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

class StockDetailsPageState extends State<StockDetailsPage> with SingleTickerProviderStateMixin {
  ListEnity enity;
  List StockComments = [];
  List<SellAndBuy> sellList = [];
  List<SellAndBuy> buyList = [];


  String type;

  String url = "";
  int index = 1;
  UserInfo userInfo;
  Setting setting;
  Stock stock;

  bool loading = false;

  Iterable<Widget> get actorWidgets sync* {}

  bool isShow = false;

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
    setState(() {
      type = enity.type;
    });
    initData();
  }

  loadHTML() {
    print(url);
    flutterWebviewPlugin.launch(
      url,
      clearCache: true,
      withZoom: false,
      rect: new Rect.fromLTWH(
          0.0, 210.0, MediaQuery.of(context).size.width, 270.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isShow) {
      this.loadHTML();
    }

    setState(() {
      isShow = true;
    });

    Widget body = stock == null
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
    Stock stock = enity.data;
    loadStockData(1, stock.stock_code2);

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

   // ignore: non_constant_identifier_names
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
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => AddStrategyPage(enity.data, userInfo))).then((res){
                    print("返回的回调 ======================== $res");
                    setState(() {
                      isShow = false;
                    });
            flutterWebviewPlugin.show();

          });
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
            Text(stock != null ? stock.name : "",
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text(stock != null ? stock.stock_code : "",
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
          isShow = false;
          url = i == 1
              ? "$host/api/client/marker/timeline/${stock.stock_code}"
              : "$host/api/client/marker/kline/${stock.stock_code}";
        });
      },
    );
  }

  Widget getSellAndBuy() {
    return Container(
        margin: EdgeInsets.only(top: 290),
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
                              stock.today_open.toStringAsFixed(2),
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
                              (stock.traded_num / 1000000).toStringAsFixed(2) + "万手",
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
                            stock.yesterday_close.toStringAsFixed(2),
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
                            (stock.traded_amount / 10000).toString() + "万",
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


  Future<Null> pullToRefresh() async {
    loadStockData(2, this.stock.stock_code2);
    return null;
  }

  loadStockData(int requestType, String code) {
    String url = "http://hq.sinajs.cn/list=" + code;

    fetch(url).then((data) {
      List<String> stockstrs = data.split(";");
      String str = stockstrs[0];
      Stock dealStocks = DealStocks(str);
      String dealUrl = "$host/api/client/marker/timeline/" + dealStocks.stock_code;

      setState(() {
        stock = dealStocks;
        stock.gains = ComputeGainsRate(dealStocks.yesterday_close, dealStocks.current_prices, dealStocks.today_open);

        sellList = [];
        buyList = [];

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

        url = dealUrl;
      });

      flutterWebviewPlugin.reloadUrl(dealUrl);
      if (requestType == 2) {
        ShowToast("刷新成功");
      }
    }).catchError((e) {});
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }


  ShowPrices() {
    Color showColor;
    String gainsNum = ComputeGainsNum(stock.yesterday_close, stock.current_prices, stock.today_open);
    String gainsStr = (stock.gains * 100).toStringAsFixed(2) + "%";
    if (stock.gains > 0) {
      showColor = Colors.red;
      gainsStr = "+" + gainsStr;
      gainsNum = "+" + gainsNum;
    } else if (stock.gains < 0) {
      showColor = Colors.green;
    } else {
      showColor = Colors.black38;
    }
    return new Container(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              stock.current_prices.toStringAsFixed(2),
              style: new TextStyle(fontSize: 24.0, color: showColor),
            ),
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
            alignment: FractionalOffset.topLeft,
          ),
          new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    gainsNum,
                    style: new TextStyle(fontSize: 12.0, color: showColor),
                    textAlign: TextAlign.left,
                  ),
                  alignment: FractionalOffset.bottomLeft,
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    gainsStr,
                    style: new TextStyle(fontSize: 12.0, color: showColor),
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
