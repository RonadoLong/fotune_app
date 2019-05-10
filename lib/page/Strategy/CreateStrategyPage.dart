import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/page/stock/AddStrategyPage.dart';
import 'package:fotune_app/page/stock/SelectedWidget.dart';
import 'package:fotune_app/page/stock/StockSearchPage.dart';
import 'package:fotune_app/page/stock/model/Setting.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/utils/AdaptUtils.dart';
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
  @override
  State<StatefulWidget> createState() => new CreateStrategyPageState();
}

class CreateStrategyPageState extends State<CreateStrategyPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
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

  double scrY = AdaptUtils.px(350);

  String code = "sz002230";

  @override
  bool get wantKeepAlive => true;

  @protected
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      print(offset);
      flutterWebviewPlugin.resize(new Rect.fromLTWH(0.0, scrY - offset,
          MediaQuery.of(context).size.width, AdaptUtils.px(540)));
    });

    bus.on("changeTabStatus", (arg) {
      if (this.mounted) {
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
    bus.on("login", (arg) {
      loadUser();
    });

    bus.on("logout", (arg) {
      setState(() {
        userInfo = null;
      });
    });

    initData();

     Timer countdownTimer =  new Timer.periodic(new Duration(seconds: 5), (timer) {
        print("time to TimeLine data");
        print(timer.tick);
        initData();
    });
   
  }

  Container renderSearch() {
    return Container(
      height: 36,
      color: Colors.white,
      padding: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 6),
              ),
              Text(stock.name,
                  style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: UIData.normal_font_color)),
              Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Text(stock.stock_code,
                  style: new TextStyle(
                      fontSize: 13.0,
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
                if (call != null && call != "") {
                  setState(() {
                    code = call;
                  });
                  loadStockData(1, call);
                }
                flutterWebviewPlugin.show();
              });
            },
            color: UIData.primary_color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "查看更多",
                  style: TextStyle(color: Colors.white),
                ),
                Padding(padding: EdgeInsets.only(left: 4)),
                Icon(
                  Icons.search,
                  color: Colors.white,
                )
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
            0.0, scrY, MediaQuery.of(context).size.width, AdaptUtils.px(540)),
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
            onRefresh: (() => pullToRefresh()),
            color: UIData.refresh_color, //刷新控件的颜色
            child: ListView.separated(
              controller: _scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return mainWidget();
              },
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, idx) {
                return Container(
                  height: 5,
                  color: Color.fromARGB(50, 183, 187, 197),
                );
              },
            ));

    return Scaffold(
      body: body,
    );
  }

  void initData() {
    loadStockData(1, this.code);
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
      children: <Widget>[
        renderSearch(),
        TopMarket(),
        getKline(),
        getSellAndBuy(),
        buildBottom()
      ],
    );
  }

  Widget buildBottom() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: RaisedButton(
        onPressed: () {
          loadUser();
          flutterWebviewPlugin.hide();
          User user = GetLocalUser();
          if (user == null) {
            GotoLoginPage(context).then((val) {
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

  Widget getKline() {
    return SelectedWidget(
      (i) {
        setState(() {
          isShow = false;
          url = i == 1
              ? "$host/api/client/marker/timeline/" + stock.stock_code
              : "$host/api/client/marker/kline/" + stock.stock_code;
          flutterWebviewPlugin.reloadUrl(url);
        });
      },
    );
  }

  Widget getSellAndBuy() {
    return Container(
      margin: EdgeInsets.only(top: AdaptUtils.px(580)),
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
      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      color: Colors.white,
      height: 30.0,
      child: ShowPrices(),
    );
  }

  Future<Null> pullToRefresh() async {
    loadStockData(2, this.stock.stock_code2);
    loadUser();
    return null;
  }

  loadStockData(int requestType, String code) {
    String url = "http://hq.sinajs.cn/list=" + code;

    fetch(url).then((data) {
      List<String> stockstrs = data.split(";");
      String str = stockstrs[0];
      Stock dealStocks = DealStocks(str);

      if (this.mounted) {
        setState(() {
          stock = dealStocks;
          stock.gains = ComputeGainsRate(dealStocks.yesterday_close,
              dealStocks.current_prices, dealStocks.today_open);

          sellList = [];
          buyList = [];

          url = "$host/api/client/marker/timeline/" + dealStocks.stock_code;
          flutterWebviewPlugin.reloadUrl(url);
          
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

  Container ShowPrices() {
    Color showColor;
    String gainsNum = ComputeGainsNum(
        stock.yesterday_close, stock.current_prices, stock.today_open);
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
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            stock.current_prices.toStringAsFixed(2),
            style: new TextStyle(fontSize: 24.0, color: showColor),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Text(
            gainsNum,
            style: new TextStyle(fontSize: 12.0, color: showColor),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Text(
            gainsStr,
            style: new TextStyle(fontSize: 12.0, color: showColor),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
