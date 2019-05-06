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
    var createPage = CreateStrategyPage();
    var bus = new EventBus();

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: new Text(title, style: new TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: UIData.primary_color,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "创建策略"),
                Tab(text: "我的策略"),
                Tab(text: "结算策略"),
              ],
              isScrollable: false,
              onTap: (index) {
                print("changeTabStatus");
                var idx = index == 0 ? true : false;
                bus.emit("changeTabStatus", idx);
              }
            ),
          ),
          body: TabBarView(
            children: [
              createPage,
              MyStrategyPage(""),
              FinishStrategyPage(""),
            ],
          ),
        ),
      ),
    );
  }
}
