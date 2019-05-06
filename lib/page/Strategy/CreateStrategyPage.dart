import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/WBSearchInputWidget.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/page/stock/AddStrategyPage.dart';
import 'package:fotune_app/page/stock/SelectedWidget.dart';
import 'package:fotune_app/page/stock/StockSearchPage.dart';
import 'package:fotune_app/page/stock/model/Setting.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/utils/Compute.dart';
import 'package:fotune_app/utils/NavigatorUtils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SellAndBuy {
  String label;
  var price;
  var num;

  SellAndBuy(this.label, this.price, this.num);
}

class CreateStrategyPage extends StatefulWidget {

  bool initShow = false;

  @override
  State<StatefulWidget> createState() => new CreateStrategyPageState();
}

class CreateStrategyPageState extends State<CreateStrategyPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  Stock stock;
  UserInfo userInfo;

  var bus = new EventBus();
  int isShowIdx = 0;

  List StockComments = [];
  List<SellAndBuy> sellList = [];
  List<SellAndBuy> buyList = [];

  String url = "";
  int index = 1;
  Setting setting;

  bool loading = false;

  Iterable<Widget> get actorWidgets sync* {}

  bool isShow = true;

  bool isCurrent = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    bus.on("changeTabStatus", (arg) {
      if (this.mounted){
        setState(() {
          isCurrent = arg;
        });
      }
      if (arg) {
        this.loadHTML();
      } else {
        flutterWebviewPlugin.dispose();
        flutterWebviewPlugin.close();
      }
    });

    bus.on("changeTimeLineStatus", (arg) {
      if (arg && isCurrent) {
        this.loadHTML();
      } else {
        flutterWebviewPlugin.dispose();
        flutterWebviewPlugin.close();
      }
    });

    // 监听登录事件
    bus.on("login", (arg){
      loadUser();
    });

    bus.on("logout", (arg){
       setState(() {
         userInfo = null;
       });
    });

    initData();

    loadUser();
  }

  Container renderSearch() {
    return Container(
      height: 50,
      color: Colors.white,
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10),),
                Text(stock.name,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: UIData.normal_font_color)),
                Padding(padding: EdgeInsets.only(left: 10),),
                Text(stock.stock_code,
                    style: new TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w200,
                        color: UIData.normal_font_color)),
              ],
            ),
            RaisedButton(
              onPressed: () {
                flutterWebviewPlugin.hide();
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockSearchPage(true)))
                      .then((call) {
                        print(call);
                      if(call != null && call != "") {
                        loadStockData(1, call);
                      }
                      flutterWebviewPlugin.show();
                  });
              },
              color: UIData.primary_color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("查看更多", style: TextStyle(color: Colors.white),),
                  Padding(padding: EdgeInsets.only(left: 4)),
                  Icon(Icons.search, color: Colors.white,)
                ],
              ),
            ),
        ],
      ),
    );
  }

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  loadHTML() {
    if (context != null) {
      flutterWebviewPlugin.launch(
      url,
      clearCache: true,
      withZoom: false,
      rect: new Rect.fromLTWH(
          0.0, 310.0, MediaQuery.of(context).size.width, 270.0),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
    loadStockData(1, "sz002230");
    loadUser();
  }

  void loadUser() {
    User user = GetLocalUser();
    if (user == null) {
    } else {
      GetUserInfo(user.user_id).then((res) {
        if (res.code == 1000) {
          if (this.mounted) {
            setState(() {
            userInfo = res.data;
          });
          }
        }
      });
    }
  }

  Widget mainWidget() {
    return Column(
      children: <Widget>[renderSearch(), TopMarket(), getKline(), getSellAndBuy(), buildBottom()],
    );
  }


  Widget buildBottom() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      child: RaisedButton(
        onPressed: () {
          flutterWebviewPlugin.hide();
          if (this.userInfo == null) {
            GotoLoginPage(context).then((val){
              flutterWebviewPlugin.show();
            });
            return;
          } 

          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      AddStrategyPage(this.stock, userInfo))).then((res) {
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

  // buildAppBar() {
  //   return AppBar(
  //     iconTheme: new IconThemeData(color: Colors.white),
  //     brightness: Brightness.light,
  //     backgroundColor: UIData.primary_color,
  //     title: Container(
  //       margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
  //       child: Column(
  //         children: <Widget>[
  //           Text(stock.name,
  //               style: new TextStyle(
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white)),
  //           Text(stock.stock_code,
  //               style: new TextStyle(
  //                   fontSize: 12.0,
  //                   fontWeight: FontWeight.w200,
  //                   color: Colors.white)),
  //         ],
  //       ),
  //     ),
  //     centerTitle: true,
  //   );
  // }

  Widget getKline() {
    return SelectedWidget(
      (i) {
        setState(() {
          isShow = false;
          url = i == 1
              ? "$host/api/client/marker/timeline/" + stock.stock_code
              : "$host/api/client/marker/kline/"+ stock.stock_code;
              flutterWebviewPlugin.reloadUrl(url);
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
        ),
    );
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

        if(this.mounted) {
           setState(() {
            stock = dealStocks;
            stock.gains = ComputeGainsRate(dealStocks.yesterday_close, dealStocks.current_prices, dealStocks.today_open);

            sellList = [];
            buyList = [];

            url = "$host/api/client/marker/timeline/" + dealStocks.stock_code;

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
          });
        }

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
    String gainsNum =
        ComputeGainsNum(stock.yesterday_close, stock.current_prices, stock.today_open);
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
