import 'package:flutter/material.dart';
import 'package:fotune_app/page/Profile/FundDetailsPage.dart';
import 'package:fotune_app/utils/UIData.dart';

class FundDetailsParentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: new Text("资金明细", style: new TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme: new IconThemeData(color: Colors.white),
            backgroundColor: UIData.primary_color,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "全部"),
                Tab(text: "收人"),
                Tab(text: "支出"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FundDetailsPage(0),
              FundDetailsPage(1),
              FundDetailsPage(-1),
            ],
          ),
        ),
      ),
    );
  }
}
