import 'package:flutter/material.dart';
import 'package:fotune_app/page/Strategy/CreateStrategyPage.dart';
import 'package:fotune_app/page/Strategy/FinishStrategyPage.dart';
import 'package:fotune_app/page/Strategy/MyStrategyPage.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/utils/UIData.dart';

class StrategyPage extends StatefulWidget {
    String title;

  StrategyPage(this.title);

  @override
  State<StatefulWidget> createState() {
    return StrategyPageState(title);
  }

}

class StrategyPageState extends State<StrategyPage> with SingleTickerProviderStateMixin{
  String title;
  StrategyPageState(this.title);
  TabController _tabController;
  var bus = new EventBus();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3) ;
    _tabController.addListener((){
      print("===========${_tabController.index}");
           var idx = _tabController.index == 0 ? true : false;
                bus.emit("changeTabStatus", idx);
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: UIData.primary_color,
             flexibleSpace: SafeArea(
              child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3.0,
              isScrollable: false,
              tabs: [
                Tab(text: "创建策略"),
                Tab(text: "我的策略"),
                Tab(text: "结算策略"),
              ],
              onTap: (index) {
                var idx = index == 0 ? true : false;
                bus.emit("changeTabStatus", idx);
              }
            ),
            ),
            // bottom: 
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              CreateStrategyPage(),
              MyStrategyPage(""),
              FinishStrategyPage(""),
            ],
          ),
        ),
      ),
    );
  }
}
