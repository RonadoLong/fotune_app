import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/api/Setting.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Home/NewsDetailsPage.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/page/stock/DiscoverWidget.dart';
import 'package:fotune_app/page/stock/model/Setting.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class AddStrategyPage extends StatefulWidget {
  Stock stock;
  UserInfo userInfo;

  AddStrategyPage(this.stock, this.userInfo);

  @override
  State<StatefulWidget> createState() {
    return AddStrategyPageState(stock, userInfo);
  }
}

class AddStrategyPageState extends State<AddStrategyPage> {
  Stock stock;
  UserInfo userInfo;

  AddStrategyPageState(this.stock, this.userInfo);

  int index = 1;
  Setting setting;
  bool loading = false;
  List isCheck = [false, false, false, false];
  List<int> promisePriceList = [];
  List<int> beiShuList = [];

  Iterable<Widget> get actorWidgets sync* {}
  int currentSelectedPrice = 0;
  int currentSelectedBeiShu = 0;

  int amount = 0;
  int stockCount = 0;

  var bus = new EventBus();

  @override
  void initState() {
    super.initState();
    GetSettings().then((res) {
      if (res.code == 1000) {
        setState(() {
          setting = Setting.fromJson(res.data);
          setting.credit.split(",").forEach((e) {
            promisePriceList.add(int.parse(e));
          });
          setting.multiple.split(",").forEach((v) {
            beiShuList.add(int.parse(v));
          });
          currentSelectedPrice = promisePriceList[0];
          currentSelectedBeiShu = beiShuList[0];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String code = stock == null ? "" : stock.stock_code2;
    String name = stock == null ? "" : stock.name;

    List<Widget> widgetList = new List();
    for (int choiceSub in promisePriceList) {
      widgetList.add(ChoiceChip(
        backgroundColor: Colors.black12,
        selectedColor: Colors.red,
        label: Text(
          '$choiceSub',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
        ),
        labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
        labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onSelected: (bool value) {
          setState(() {
            currentSelectedPrice = choiceSub;
          });
        },
        selected: currentSelectedPrice == choiceSub,
      ));
    }

//             策略倍数
    List<Widget> beishuListW = new List();
    beishuListW.add(Text(
      "策略倍数: ",
      style: TextStyle(fontSize: 14),
    ));
    for (int choiceSub in beiShuList) {
      beishuListW.add(ChoiceChip(
        backgroundColor: Colors.black12,
        selectedColor: Colors.red,
        label: Text('$choiceSub'),
        labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
        labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onSelected: (bool value) {
          setState(() {
            currentSelectedBeiShu = value ? choiceSub : value;
          });
        },
        selected: currentSelectedBeiShu == choiceSub,
      ));
    }

    var priceController =
        new TextEditingController(text: '$currentSelectedPrice');
    var amount = currentSelectedPrice * currentSelectedBeiShu;

    // 操盘资金 / 限价 = 股数
    double count = amount.ceilToDouble() / stock.current_prices / 100;

    if (count >= 1) {
      stockCount = count.toInt() * 100;
    } else {
      stockCount = 0;
    }
    String liYong =
        (stockCount * stock.current_prices / amount * 100).toStringAsFixed(2);
    double liYongCount = double.parse(liYong);

    return Scaffold(
        appBar: new AppBar(
          title: new Text("添加策略", style: new TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: UIData.primary_color,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop("退出");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildContent(
                "添加策略",
                code,
                name,
                currentSelectedPrice,
                amount,
                userInfo,
                stockCount,
                liYongCount,
                priceController,
                widgetList,
                beishuListW,
                (index) {
                  showProtocol(index);
                },
              ),
              buildBottom()
            ],
          ),
        ));
  }

  Future showProtocol(int index) async {
    var responseBody;
    var url = "$host/api/client/protocol/$index";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new NewsDetailsPage("", responseBody)));
    } else {
      print("error");
    }
  }

  Widget buildBottom() {
    return loading == false
        ? Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 40,
            child: RaisedButton(
              onPressed: () {
                if (userInfo.amount == 0) {
                  ShowToast("您的账户余额不足请前往充值");
                  return;
                }
                if (loading) {
                  return;
                }
                setState(() {
                  loading = true;
                });
                var addStrategyReq = {
                  "uid": userInfo.id,
                  "stockCode": stock.stock_code,
                  "stockName": stock.name,
                  "multiple": currentSelectedBeiShu,
                  "stockCount": stockCount,
                };
                AddStrategy(addStrategyReq).then((res) {
                  setState(() {
                    loading = false;
                  });
                  if (res.code == 1000) {
                    ShowToast("添加成功");
                    bus.emit("refreshMineStrategyData", true);
                    handleRefresh(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    ShowToast(res.msg);
                  }
                }).catchError((res) {
                  setState(() {
                    loading = false;
                  });
                  ShowToast("网络出错，请重试");
                });
              },
              color: UIData.primary_color,
              child: Text(
                "提 交",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 18),
            width: 60.0,
            height: 60.0,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
                color: UIData.primary_color,
                borderRadius:
                    new BorderRadius.all(const Radius.circular(30.0))),
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
  }
}
