import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Profile/BankManagePage.dart';
import 'package:fotune_app/page/Profile/model/BankResp.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'dart:isolate';

class BankPage extends StatefulWidget {
  UserInfo userInfo;

  BankPage(UserInfo userInfo) {
    this.userInfo = userInfo;
  }

  @override
  State<StatefulWidget> createState() {
    return BankPageState();
  }
}

class BankPageState extends State<BankPage> {
  List<Banks> dataList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    GetBankList(widget.userInfo.id).then((res) {
      if (res.code == 1000) {
        BankResp bankResp = BankResp.fromJson(res.data);
        setState(() {
          dataList = bankResp.banks;
        });
      } else if (res.code == 1004) {
        setState(() {
          dataList = [];
        });
      }
    }).catchError((err) {
      ShowToast("网络出错");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("银行卡管理", context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (dataList == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: UIData.refresh_color,
        ),
      );
    } else if (dataList.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildBodyNotHaveBank(),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text("   每人最多绑定一张银行卡,点击卡片可修改原银行卡信息"),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          print("=================");
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BankManagePage(widget.userInfo, dataList[0])))
              .then((callBack) {
            if (callBack) {
              loadData();
            }
          });
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 44,
                      width: 64,
                      child: Image.network(
                          "http://gp.axinmama.com/public/static/home/img/moblie/yl.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          dataList[0].bankName,
                          style: TextStyle(
                              color: UIData.normal_font_color, fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(dataList[0].cardNumber),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text(
                "   每人最多绑定一张银行卡,点击卡片可修改原银行卡信息",
                style: TextStyle(fontSize: 14),
                maxLines: 2,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildBodyNotHaveBank() {
    return GestureDetector(
      onTap: () {
        print("=================");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BankManagePage(
                widget.userInfo, dataList.length > 0 ? dataList[0] : null),
          ),
        );
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
