import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/cell.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Profile/model/BankResp.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_picker/flutter_picker.dart';

class BankManagePage extends StatefulWidget {
  UserInfo userInfo;
  Banks banks;

  BankManagePage(UserInfo userInfo, Banks banks) {
    this.userInfo = userInfo;
    this.banks = banks;
  }

  @override
  State<StatefulWidget> createState() {
    return BankManagePageState(banks);
  }
}

class BankManagePageState extends State<BankManagePage> {
  var address;
  String addStr = "请选择";
  String bankNormal = "请选择银行";
  bool isSumit;

  Banks banks;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String stateText;

  BankManagePageState(Banks banks) {
    this.banks = banks;
  }

  @override
  void initState() {
    super.initState();
    if (banks == null) {
      setState(() {
        banks = new Banks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("管理", context),
      body: buildCell(),
    );
  }

  show(context) async {
    var temp = await CityPickers.showCityPicker(
      context: context,
      locationCode: '440000',
      height: 400,
    );
    print(temp);
    setState(() {
      banks.province =temp.provinceName;
      banks.city =temp.cityName;
      addStr = temp.provinceName + " " + temp.cityName;
    });
  }

  showPickerIcons(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter(data: [
          new PickerItem(text: buildBankText("中国银行"), value: "中国银行"),
          new PickerItem(text: buildBankText("中国银行"), value: "中国银行"),
          new PickerItem(text: buildBankText("中国银行"), value: "中国银行"),
          new PickerItem(text: buildBankText("中国银行"), value: "中国银行"),
          new PickerItem(text: buildBankText("中国银行"), value: "中国银行"),
        ]),
        height: 200,
        columnPadding: EdgeInsets.all(10),
        cancelText: "取消",
        confirmText: "确定",
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            banks.bankName = bankNormal = picker.getSelectedValues()[0];
          });
        }).showModal(context);
  }

  void showModel(BuildContext context, String title, int index) {
    String val;
    if (index == 1) {
      val = banks.branchName != null ? banks.branchName : "";
    } else {
      val = banks.cardNumber != null ? banks.cardNumber : "";
    }
    var phoneController = TextEditingController(text: val);

    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: 100,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: phoneController,
                        autofocus: false,
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "取消",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black26,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("确认", style: TextStyle(color: Colors.white)),
                color: UIData.primary_color,
                onPressed: () {
                  var price = phoneController.text.trim();
                  if (price.length == 0) {
                    ShowToast("完善信息");
                    return;
                  }
                  print(phoneController.text);
                  setState(() {
                    if (index == 1) {
                      banks.branchName = price;
                    } else {
                      banks.cardNumber = price;
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget buildBankText(String text) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Text(text),
    );
  }

  Widget buildCell() {
    String add = banks.id != null ? banks.province + " " + banks.city : addStr;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          SyCell(
            title: "姓名",
            endText: widget.userInfo.idCard == ""
                ? "请先绑定身份证"
                : widget.userInfo.realName,
            onTap: widget.userInfo.idCard == "" ? () {} : null,
          ),
          SyCell(
            title: "开户银行",
            endText: banks.bankName == null ? bankNormal : banks.bankName,
            onTap: () {
              showPickerIcons(context);
            },
          ),
          SyCell(
            title: "所在地址",
            endText: add,
            onTap: () async {
              show(context);
            },
          ),
          SyCell(
            title: "支行名称",
            endText: banks.branchName == null ? "请输入所属支行" : banks.branchName,
            onTap: () {
              showModel(context, "请输入所属支行", 1);
            },
          ),
          SyCell(
            title: "银行卡号",
            endText: banks.cardNumber == null ? "请输入您的银行卡" : banks.cardNumber,
            onTap: () {
              showModel(context, "请输入您的银行卡", 2);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            "  1.绑定银行卡前请先进行实名认证，请务必认真填写真实资料 ",
            maxLines: 2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
          ),
          Text("  2.一个身份证只能绑定一个账号 ", maxLines: 2),
          Padding(
            padding: EdgeInsets.only(top: 4),
          ),
          Text("  3.如遇问题，请联系客服", maxLines: 2),
          Padding(
            padding: EdgeInsets.only(top: 40),
          ),
          Center(
            child: ButtonTheme(
              buttonColor: UIData.primary_color,
              minWidth: 300.0,
              height: 44.0,
              child: RaisedButton(
                onPressed: () {
                  var addReq = {
                    "uid": widget.userInfo.id,
                    "accountHolder": widget.userInfo.realName,
                    "bankName": banks.bankName,
                    "province": banks.province,
                    "city": banks.city,
                    "branchName": banks.branchName,
                    "cardNumber": banks.cardNumber,
                  };
                  print(addReq);
                  AddBank(addReq).then((res) {
                    if (res.code == 1000) {
                      ShowToast("添加成功");
                      Navigator.of(context).pop("addres");
                    }
                  });
                },
                child: Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
