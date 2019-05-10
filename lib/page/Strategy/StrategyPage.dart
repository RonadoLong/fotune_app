import 'package:flutter/material.dart';
import 'package:fotune_app/page/Strategy/CreateStrategyPage.dart';
import 'package:fotune_app/page/Strategy/FinishStrategyPage.dart';
import 'package:fotune_app/page/Strategy/MyStrategyPage.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/utils/UIData.dart';


class StrategyPage extends StatelessWidget {
  String title;

  StrategyPage(this.title);
  @override
  Widget build(BuildContext context) {
    var bus = new EventBus();

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: UIData.primary_color,
             flexibleSpace: SafeArea(
              child: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3.0,
              tabs: [
                Tab(text: "创建策略"),
                Tab(text: "我的策略"),
                Tab(text: "结算策略"),
              ],
              isScrollable: false,
              onTap: (index) {
                var idx = index == 0 ? true : false;
                bus.emit("changeTabStatus", idx);
              }
            ),
            ),
            // bottom: 
          ),
          body: TabBarView(
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
