import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/WBSearchInputWidget.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/stock/model/Stock.dart';
import 'package:fotune_app/utils/UIData.dart';

class CreateStrategyPage extends StatefulWidget {
  Stock stock;

  CreateStrategyPage(this.stock);

  @override
  State<StatefulWidget> createState() {
    return new CreateStrategyPageState(stock);
  }
}

class CreateStrategyPageState extends State<CreateStrategyPage> {
  Stock stock;
  UserInfo userInfo;
  CreateStrategyPageState(this.stock);

  @override
  void initState() {
    super.initState();
    User user = GetLocalUser();
    if (user == null) {
      return;
    }
    GetUserInfo(user.user_id).then((res) {
      if (res.code == 1000) {
        setState(() {
          userInfo = res.data;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Container renderHeader() {
    String codeName = stock.stock_code2;
    double amount = userInfo.amount;
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              stock.name,
              style: TextStyle(
                  color: UIData.grey_color,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "代号: $codeName",
                  style: TextStyle(
                      color: UIData.primary_color,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "账户资金: $amount",
                  style: TextStyle(
                      color: UIData.primary_color,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  WBSearchInputWidget renderSearch() {
    return WBSearchInputWidget(
      (val) {
        print("change === $val");
      },
      (val) {
        print("change === $val");
      },
      () {
        print("onSubmitPressed === ");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget header =
        userInfo == null ? CircularProgressIndicator() : renderHeader();
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("添加策略", context),
      body: Column(
        children: <Widget>[
          header,
        ],
      ),
    );
  }
}
