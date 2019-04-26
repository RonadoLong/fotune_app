import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Profile/model/BankResp.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class TiXianPage extends StatefulWidget {
  UserInfo userinfo;
  TiXianPage(UserInfo userInfo) {
    this.userinfo = userInfo;
  }

  @override
  State<StatefulWidget> createState() {
    return TiXianPageState();
  }
}

class TiXianPageState extends State<TiXianPage> {
  int price;
  final priceController = new TextEditingController();
  Banks banks;

  @override
  void initState() {
    super.initState();
      GetBankList(widget.userinfo.id).then((res) {
      if (res.code == 1000) {
        BankResp bankResp = BankResp.fromJson(res.data);
        setState(() {
          banks = bankResp.banks[0];
        });
      } else if (res.code == 1004) {
        
      }
    }).catchError((err) {
//      ShowToast("网络出错");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("提现", context),
      body: widget.userinfo.idCard == ""
          ? Center(child: buildEmptyView())
          : buildBody(),
    );
  }

  Widget buildBody() {
    double btnM = (MediaQuery.of(context).size.width - 240) * 0.5;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Text(" 选择提现到账方式"),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: new InputDecoration(
                    hintText: "输入提现金额",
                    icon: new Icon(Icons.memory),
                  ),
                ),
                Container(
                  height: 44,
                  child: Row(
                    children: <Widget>[
                      Text("银行卡"),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                      ),
                      Text(banks.cardNumber),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text("账户可用余额:${widget.userinfo.amount}元，当余额小于10元须全额提现"),
          ),
          Container(
            margin: EdgeInsets.only(left: btnM, top: 30),
            child: ButtonTheme(
              buttonColor: UIData.primary_color,
              minWidth: 240.0,
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  print(priceController.text);
                  var priceStr = priceController.text.trim();
                  if (priceStr.length == 0) {
                    ShowToast("请输入");
                    return;
                  }
                  var price = double.parse(priceStr);
                  var req = {
                    "uid": widget.userinfo.id,
                    "amount": price,
                  };
                  PostTiXian(req).then((res) {
                    if (res.code == 1000) {
                      ShowToast("提交成功，等待处理");
                      Navigator.of(context).pop("change");
                    } else {
                      ShowToast("提现失败，请联系管理员");
                    }
                  }).catchError((err) {
                    print(err);
                    ShowToast("提现失败，请联系管理员");
                  });
                },
                highlightColor: UIData.primary_color,
                child: Text("提现"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  "提现无任何形式手续费",
                  style: TextStyle(color: UIData.grey_color),
                ),
                Text("具体到账时间以银行到账时间为准"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildEmptyView() {
    return Container(
      height: 160,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.network_check,
            size: 50,
            color: UIData.refresh_color,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "您还没添加银行卡",
            style: TextStyle(fontSize: 16, color: UIData.normal_font_color),
          )
        ],
      ),
    );
  }
}
