import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/ListEnity.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/stock/StockDetailsPage.dart';
import 'package:fotune_app/page/stock/StockSearchPage.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';
import 'package:fotune_app/utils/Compute.dart';
import 'package:fotune_app/utils/NavigatorUtils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  List<Stock> stocks;
  List<StockIndex> stockIndexs = [];
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: new Center(child: getBody()),
    );
  }

  @override
  void initState() {
    super.initState();
    getDataIndex(1);
    loadData();
  }

  loadData() {
    setState(() {
      user = GetLocalUser();
    });
    if (user != null) {
      GetOptionalList(user.user_id).then((res) {
        if (res.code == 1000) {
          print(res.data);
          if (res.data != "") {
            getStocks(1, res.data.toString());
          } else {
            setState(() {
              stocks = [];
            });
          }
        }
      });
    } else {
      setState(() {
        stocks = [];
      });
    }
  }

  Widget buildEmptyView() {
    return Container(
      height: 160,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.network_check,
            size: 50,
            color: UIData.refresh_color,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "您还没添加自选, 点击右上角按钮添加",
            style: TextStyle(fontSize: 14, color: UIData.normal_font_color),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        "自选",
        style: new TextStyle(color: Colors.white),
      ),
      backgroundColor: UIData.primary_color,
      iconTheme: new IconThemeData(color: Colors.white),
      actions: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_to_photos),
              onPressed: () {
                if (user == null) {
                  GotoLoginPage(context).then((res) {
                    loadData();
                  });
                } else {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockSearchPage()))
                      .then((call) {
                    loadData();
                  });
                }
              },
              tooltip: "添加",
            ),
            Text(" "),
          ],
        )
      ],
    );
  }

  void getStocks(int requestType, String code) {
    if (stocks == null) {
      stocks = [];
    }
    stocks.clear();
    stocks.add(new Stock());
    String url = "http://hq.sinajs.cn/list=" + code;
    fetch(url).then((data) {
      setState(() {
        List<String> stockStrs = data.split(";");
        for (int i = 0; i < (stockStrs.length - 1); i++) {
          String str = stockStrs[i];
          Stock stock = new Stock();
          stocks.add(DealStocks(str, stock));
        }
      });
    }).catchError((e) {
      ShowToast("网络出错");
    });
  }

  void getDataIndex(int request_type) {
    String url = "http://hq.sinajs.cn/list=s_sz399001,s_sz399006,s_sh000001";
    fetch(url).then((data) {
//      print("指数数据==》" + data);
      setState(() {
        List<String> index_strs = data.split(";");
        setState(() {
          for (int i = 0; i < (index_strs.length - 1); i++) {
            String str = index_strs[i];
            StockIndex stockIndex = new StockIndex();
            DealStockIndess(str, stockIndex);
            stockIndexs.add(stockIndex);
          }
        });
      });
    }).catchError((e) {
      ShowToast("网络出错");
    });
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  getBody() {
    if (stocks == null) {
      return CircularProgressIndicator(
        backgroundColor: UIData.refresh_color,
      );
    } else {
      return new Container(
        child: new RefreshIndicator(
            child: getListView(), onRefresh: pullToRefresh),
        alignment: FractionalOffset.topLeft,
      );
    }
  }

  getListView() {
    return ListView.builder(
      itemCount: (stocks.length == 0) ? 2 : stocks.length,
      itemBuilder: (BuildContext context, int position) {
        return getItem(position);
      },
      physics: new AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  getItem(int position) {
    if (position == 0) {
      return TopWidget();
    } else {
      if (stocks.length == 0) {
        return buildEmptyView();
      } else {
        return getListViewItem(position);
      }
    }
  }

  //显示涨幅
  ShowGains(double gains) {
    Color show_color;
    String gains_str = (gains * 100).toStringAsFixed(2) + "%";
    if (gains > 0) {
      show_color = Colors.red;
      gains_str = "+" + gains_str;
    } else if (gains < 0) {
      show_color = Colors.green;
    } else {
      show_color = Colors.black38;
    }
    return new Container(
      color: show_color,
      padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: new Text(
        gains_str,
        style: new TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      alignment: FractionalOffset.center,
    );
  }

  Future<Null> pullToRefresh() async {
    loadData();
    return null;
  }

  TopWidget() {
    return new Container(
      height: 138.0,
      child: new Padding(
        padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            getGistView(),
            Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    child: new Text(
                      "股票名称",
                      style: new TextStyle(
                          fontSize: 14.0, color: UIData.primary_color),
                    ),
                    alignment: FractionalOffset.center,
                  ),
                  flex: 8,
                ),
                new Expanded(
                  child: new Container(
                    child: new Text(
                      "最新价",
                      style: new TextStyle(
                          fontSize: 14.0, color: UIData.primary_color),
                    ),
                    alignment: FractionalOffset.center,
                  ),
                  flex: 13,
                ),
                new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    child: new Text(
                      "涨跌幅",
                      style: new TextStyle(
                          fontSize: 14.0, color: UIData.primary_color),
                    ),
                    alignment: FractionalOffset.center,
                  ),
                  flex: 9,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getListViewItem(int position) {
    Stock stock = stocks[position];
    double yesterday_close = double.parse(stock.yesterday_close);
    double current_prices = double.parse(stock.current_prices);
    double today_open = double.parse(stock.today_open);
    double gains =
        ComputeGainsRate(yesterday_close, current_prices, today_open);
    stocks[position].gains = gains;
    String current_prices_str = current_prices.toStringAsFixed(2);
    return new GestureDetector(
      child: new Card(
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //纵向对齐方式：起始边对齐
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          stock.name,
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        alignment: FractionalOffset.topCenter,
                      ),
                      new Container(
                        child: new Text(
                          stock.stock_code,
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                        ),
                        alignment: FractionalOffset.bottomCenter,
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),
              new Expanded(
                child: new Container(
                  child: new Text(
                    current_prices_str,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  alignment: FractionalOffset.center,
                ),
                flex: 2,
              ),
              new Expanded(
                child: ShowGains(gains),
                flex: 1,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        onItimeClick(stock);
      },
    );
  }

  void onItimeClick(Stock stock) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => StockDetailsPage(ListEnity("stock", stock))));
  }

  getGistView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: buildGridList(),
    );
  }

  buildGridList() {
    List<Widget> widgetList = new List();
    for (StockIndex stockIndex in stockIndexs) {
      widgetList.add(getItemWidget(stockIndex));
    }
    return widgetList;
  }

  Widget getItemWidget(StockIndex stockIndex) {
    Color show_color;
    String gains_rate = stockIndex.gains_rate;
    String change_prefix = "";
    if (gains_rate == "0.00") {
      show_color = Colors.black38;
    } else {
      if (gains_rate.indexOf("-") == -1) {
        change_prefix = "+";
        show_color = Colors.red;
      } else {
        show_color = Colors.green;
      }
    }

    double w = (MediaQuery.of(context).size.width - 60) / 3;

    return Card(
      child: Container(
        height: 90,
        width: w,
        padding: new EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              child: Text(
                stockIndex.name,
                style: new TextStyle(fontSize: 15.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.all(2),
              child: Text(
                stockIndex.current_points,
                style: new TextStyle(fontSize: 17.0, color: show_color),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      stockIndex.current_prices,
                      style: new TextStyle(fontSize: 12.0, color: Colors.blue),
                      maxLines: 1,
                    ),
                    alignment: FractionalOffset.center,
                  ),
                  Container(
                    child: Text(
                      change_prefix + gains_rate + "%",
                      style: new TextStyle(fontSize: 12.0, color: show_color),
                      maxLines: 1,
                    ),
                    alignment: FractionalOffset.center,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
