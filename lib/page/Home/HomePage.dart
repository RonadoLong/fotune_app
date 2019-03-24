import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fotune_app/api/home.dart';
import 'package:fotune_app/page/Home/HomeWidget.dart';
import 'package:fotune_app/page/Home/model/NiuPeople.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';
import 'package:fotune_app/utils/Compute.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  Function changeTab;

  HomePage(Function change) {
    this.changeTab = change;
  }
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var title = '首页';

  List<StockIndex> markets = [];
  List<NiuPeople> niuPeoples = [];

  List<String> banners = [
    'https://gw.alipayobjects.com/zos/rmsportal/iZBVOIhGJiAnhplqjvZW.png',
  ];

  @override
  void initState() {
    super.initState();
    getDataIndex(1);
  }

  Widget getBody(BuildContext context) {
    if (markets.isEmpty || markets.length == 0) {
      return new Center(
        child: CircularProgressIndicator(
          backgroundColor: UIData.refresh_color,
        ),
      );
    } else {
      return new RefreshIndicator(
          onRefresh: (() => _handleRefresh()),
          color: UIData.refresh_color, //刷新控件的颜色
          child: ListView.separated(
            itemCount: 1,
            itemBuilder: (BuildContext context, int position) {
              return renderRow(position);
            },
            physics: new AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, idx) {
              //分割线
              return Container(
                height: 5,
                color: Color.fromARGB(50, 183, 187, 197),
              );
            },
          ));
    }
  }

  renderRow(int position) {
    if (position == 0) {
      return renderTop();
    }
  }

  Widget renderTop() {
    return Container(
      child: Column(
        children: <Widget>[
          newCarousel(banners),
          newButtonSection((int i) {
            print(i);
            if (i < 10) {
              widget.changeTab(i);
            }
          }),
//          newMoneyInfoView(),
          newQuoteView(markets),
          newNiuRenView(context, niuPeoples),
//          newInfoView(context)
        ],
      ),
    );
  }

  void getDataIndex(int request_type) {
    String url = "http://hq.sinajs.cn/list=s_sz399001,s_sz399006,s_sh000001";
    fetch(url).then((data) {
      // print("指数数据==》" + data);
      setState(() {
        List<String> indexStrings = data.split(";");
        List<StockIndex> dataList = [];
        for (int i = 0; i < indexStrings.length - 1; i++) {
          String str = indexStrings[i];
          StockIndex stockIndex = new StockIndex();
          DealStockIndess(str, stockIndex);
          dataList.add(stockIndex);
        }
        setState(() {
          markets = dataList;
        });
      });
    }).catchError((e) {
      ShowToast("加载失败");
    });

    GetNiuPeoples().then((res) {
      if (res.code == 1000) {
        setState(() {
          niuPeoples = res.data != null
              ? (res.data as List).map((n) => NiuPeople.fromJson(n)).toList()
              : null;
        });
      }
    });
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      getDataIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }
}
