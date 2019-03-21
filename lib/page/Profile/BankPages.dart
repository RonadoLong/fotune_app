import 'package:flutter/material.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/page/Profile/BankManagePage.dart';

class BankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BankPageState();
  }
}

class BankPageState extends State<BankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("银行卡管理", context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildBodyNotHaveBank(),
        ],
      ),
    );
  }

  Widget buildBodyNotHaveBank() {
    return GestureDetector(
      onTap: () {
        print("=================");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BankManagePage()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_box, color: Colors.black26),
            Padding(
              padding: EdgeInsets.only(left: 16),
            ),
            Text("添加银行卡"),
          ],
        ),
      ),
    );
  }
}
