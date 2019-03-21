import 'package:flutter/material.dart';
import 'package:fotune_app/page/Strategy/FinishStrategyPage.dart';
import 'package:fotune_app/page/Strategy/MyStrategyPage.dart';
import 'package:fotune_app/utils/UIData.dart';

class StrategyPage extends StatelessWidget {
  String title;

  StrategyPage(this.title);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: new Text(title, style: new TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: UIData.primary_color,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "我的策略"),
                Tab(text: "结算策略"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MyStrategyPage(),
              FinishStrategyPage(),
            ],
          ),
        ),
      ),
    );
  }
}
//
//class StrategyPageState extends State<StrategyPage>
//    with SingleTickerProviderStateMixin {
//  var title = "实盘策略";
//  TabController _controller;
//  List<_Page> _allPages = [];
//  _Page _selectedPage;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: new Text(title, style: new TextStyle(color: Colors.white)),
//        centerTitle: true,
//        iconTheme: new IconThemeData(color: Colors.white),
//        backgroundColor: UIData.primary_color,
//        bottom: TabBar(
//          tabs: [
//            Tab(icon: Icon(Icons.directions_car)),
//            Tab(icon: Icon(Icons.directions_transit)),
//            Tab(icon: Icon(Icons.directions_bike)),
//          ],
//        ),
//      ),
//      body: TabBarView(
//        children: [
//          Icon(Icons.directions_car),
//          Icon(Icons.directions_transit),
//          Icon(Icons.directions_bike),
//        ],
//      ),
//    );
//  }
//
//  void _handleTabSelection() {
//    setState(() {
//      _selectedPage = _allPages[_controller.index];
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _allPages = <_Page>[
//      _Page("创建策略"),
//      _Page("创建策略"),
//      _Page("创建策略"),
//    ];
//
//    _controller = TabController(vsync: this, length: _allPages.length);
//    _controller.addListener(_handleTabSelection);
//    _selectedPage = _allPages[0];
//  }
//}
