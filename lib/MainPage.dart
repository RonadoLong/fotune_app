import 'package:flutter/material.dart';
import 'package:fotune_app/page/Home/HomeNewsPage.dart';
import 'package:fotune_app/page/Strategy/StrategyPage.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/page/home/HomePage.dart';
import 'package:fotune_app/page/Profile/MinePage.dart';
import 'package:fotune_app/page/stock/MarketPage.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:flustars/flustars.dart';
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, home: new MainPageWidget());
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {


  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['首页', '自选', '策略', '我的'];
  var bus = new EventBus();

  var _pageList;
  final blueCode = Color(0xff1296db);
  final blueCode2 = Color(0xff515151);

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Icon getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: Colors.redAccent));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: blueCode2));
    }
  }

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 24.0, height: 24.0);
  }

  void load() async {
    await SpUtil.getInstance();

  }

  void initData() {
    load();

    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [Icon(Icons.home), Icon(Icons.home, color: UIData.primary_color)],
      [
        Icon(Icons.add_circle),
        Icon(Icons.add_circle, color: UIData.primary_color)
      ],
      [Icon(Icons.message), Icon(Icons.message, color: UIData.primary_color)],
      [
        Icon(Icons.person_pin),
        Icon(Icons.person_pin, color: UIData.primary_color)
      ],
    ];

    var titleList = ['广场', '股讯'];
    Widget home = new DefaultTabController(
      length: titleList.length,
      child: new Scaffold(
        appBar: new AppBar(
          elevation: 0.0, //导航栏下面那根线
          backgroundColor: UIData.primary_color,
          title: new TabBar(
            isScrollable: false,
            //是否可滑动
            unselectedLabelColor: Colors.black38,
            //未选中按钮颜色
            labelColor: Colors.white,
            //选中按钮颜色
            labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
            //文字样式
            indicatorSize: TabBarIndicatorSize.label,
            //滑动的宽度是根据内容来适应,还是与整块那么大(label表示根据内容来适应)
            indicatorWeight: 3.0,
            //滑块高度
            indicatorColor: Colors.white,
            //滑动颜色
            indicatorPadding: EdgeInsets.only(bottom: 1.0),
            //与底部距离为1
            tabs: titleList.map((String text) {
              //tabs表示具体的内容,是一个数组
              return new Tab(
                text: text,
              );
            }).toList(),
          ),
        ),
        //body表示具体展示的内容
        body: TabBarView(children: [HomePage(this.changeTab), HomeNewsPage()]),
      ),
    );

    /*
     * 三个子界面
     */
    _pageList = [
      home,
      new MarketPage(),
      new StrategyPage("实盘策略"),
      new MinePage(),
    ];
  }

  void changeTab(int index) {

    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //初始化数据
    initData();
   
    return Scaffold(
        body: IndexedStack(
          index: _tabIndex,
          children: _pageList,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2), title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3), title: getTabTitle(3)),
          ],
          type: BottomNavigationBarType.fixed,
          //默认选中首页
          currentIndex: _tabIndex,
          iconSize: 24.0,
          //点击事件
          onTap: (index) {
            var idx = index == 2 ? true : false;
            bus.emit("changeTimeLineStatus", idx);
            setState(() {
              _tabIndex = index;
            });
          },
        ));
  }
}
