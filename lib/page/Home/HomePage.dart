import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fotune_app/api/home.dart';
import 'package:fotune_app/page/Home/HomeWidget.dart';
import 'package:fotune_app/page/Home/NewPeoplePage.dart';
import 'package:fotune_app/page/Home/model/Carsousel.dart';
import 'package:fotune_app/page/Home/model/NiuPeople.dart';
import 'package:fotune_app/page/Profile/ChongZhiPage.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';
import 'package:fotune_app/utils/Compute.dart';
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

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  var title = '首页';
  List<StockIndex> markets = [];
  List<NiuPeople> niuPeoples = [];
  List<Carousel> banners = [];

  @override
  void initState() {
    super.initState();
    this.loadData();
  }

  loadData() {
    GetBanners().then((res) {
      print(res.code);
      if (res.code == 1000) {
        setState(() {
          banners = res.data;
        });
      }
      getDataIndex(1);
    });
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
            separatorBuilder: (context, idx) {              //分割线
              return Container(
                height: 5,
                color: Color.fromARGB(50, 183, 187, 197),
              );
            },
          )
      );
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
            } else if (i == 12) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewPeoplePage('http://gp.axinmama.com/guild.html')));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChongZhiPage()));
            }
          }),
          newQuoteView(markets),
        ],
      ),
    );
  }

  void getDataIndex(int requestType) {
    String url = "http://hq.sinajs.cn/list=s_sz399001,s_sz399006,s_sh000001";
    fetch(url).then((data) {
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
//      ShowToast("加载失败");
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
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);//必须添加
    return Scaffold(
      body: getBody(context),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
