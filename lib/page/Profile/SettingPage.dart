import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/FInputWidget.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/utils/MD5Utils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:flustars/flustars.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {
  UserInfo userInfo;
  var _userController = new TextEditingController();
  var _idCardController = new TextEditingController();

  var _orderPWDController = new TextEditingController();
  var _newPWDController = new TextEditingController();
  var _againNewController = new TextEditingController();
  var bus = new EventBus();

  String level = "中";
  double levelVal = 0.5;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    User userinfo = GetLocalUser();
    if (userinfo == null) {
      return;
    }
    GetUserInfo(userinfo.user_id).then((res) {
      if (res.code == 1000) {
        setState(() {
          userInfo = res.data;
          if (userInfo.idCard != "") {
            level = "高";
            levelVal = 1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("账户安全", context),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return renderRow(index);
          },
          separatorBuilder: (context, idx) {
            return Container(
              height: 3,
            );
          },
          itemCount: 5),
    );
  }

  renderRow(index) {
    if (index == 0) {
      return Container(
        color: Colors.white,
        height: 100,
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Text(
                      "安全评级:  ",
                      style: TextStyle(
                          color: UIData.normal_font_color,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: new LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: levelVal,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          UIData.primary_color),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      "  $level",
                      style: TextStyle(
                          color: UIData.primary_color,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Text("建议您完善全部安全设置，以保障账户及资金安全")
          ],
        ),
      );
    } else if (index == 4) {
      return Container(
        margin: EdgeInsets.all(20),
        child: new FlatButton(
            onPressed: () {
              sureDiaLog();
            },
            color: UIData.primary_color,
            child: new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Text(
                '退出登录',
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            )),
      );
    } else {
      String url = "http://gp.axinmama.com/public/static/home/img/yes.png";
      String name = "";
      String desc = "";
      String btnTitle = "";

      if (index == 1) {
        name = "实名认证";
        if (userInfo != null && userInfo.idCard != "") {
          url = "http://gp.axinmama.com/public/static/home/img/yes.png";
          desc = userInfo.idCard;
          btnTitle = "";
        } else {
          url = "http://gp.axinmama.com/public/static/home/img/no.png";
          desc = "未认证";
          btnTitle = "去认证";
        }
      } else if (index == 2) {
        url = "http://gp.axinmama.com/public/static/home/img/yes.png";
        name = "绑定手机";
        desc = userInfo != null ? userInfo.phone : "";
      } else {
        url = "http://gp.axinmama.com/public/static/home/img/yes.png";
        name = "登录密码";
        desc = "登录用的密码";
        btnTitle = "修改";
      }

      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10),
        height: 80,
        child: renderCell(url, name, desc, btnTitle),
      );
    }
  }

  void sureDiaLog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "提示",
            textAlign: TextAlign.center,
          ),
          content: new Text("是否确认退出登录"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                SpUtil.remove("userInfo").then((res) {
                  SpUtil.clear().then((res) {
                    if (res) {
                      ShowToast("退出成功");
                    
                      scheduleMicrotask((){
                        bus.emit("logout");
                      });
                      Navigator.of(context).pop();
                      pop();
                    }
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  pop() {
    Navigator.of(context).pop("退出");
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.amber[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "1. 一个身份证对应一个账号，如遇到问题，请联系客服 ",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new FInputWidget(
                  hintText: "真实姓名",
                  iconData: Icons.verified_user,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _userController,
                ),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new FInputWidget(
                  hintText: "身份证号",
                  iconData: Icons.format_indent_decrease,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _idCardController,
                ),
              ],
            ),
          ),
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
                var idcard = _idCardController.text.trim();
                var realname = _userController.text.trim();

                if (idcard.length > 12 && realname.length >= 2) {
                  var params = {
                    "uid": userInfo.id,
                    "realName": realname,
                    "idCard": idcard,
                  };
                  BindRealName(params).then((res) {
                    if (res.code == 1000) {
                      ShowToast("绑定成功");
                      Navigator.of(context).pop();
                      this.loadData();
                    } else {
                      ShowToast("绑定失败，请联系客服");
                    }
                  });
                } else {
                  ShowToast("您填写的信息有误");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpdatePwdDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: new EdgeInsets.all(5.0)),
                new FInputWidget(
                  hintText: "当前密码",
                  iconData: Icons.verified_user,
                  obscureText: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _orderPWDController,
                ),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new FInputWidget(
                  hintText: "新密码",
                  iconData: Icons.verified_user,
                  obscureText: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _newPWDController,
                ),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new FInputWidget(
                  hintText: "确认密码",
                  iconData: Icons.format_indent_decrease,
                  obscureText: true,
                  onChanged: (String value) {
                    print(value);
                  },
                  controller: _againNewController,
                ),
              ],
            ),
          ),
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
                var ordPWD = _orderPWDController.text.trim();
                var newPwd = _newPWDController.text.trim();
                var againPwd = _againNewController.text.trim();

                if (ordPWD.length >= 6 &&
                    newPwd.length >= 6 &&
                    againPwd == newPwd) {
                  if (ordPWD == newPwd) {
                    ShowToast("新旧密码不能一样");
                    return;
                  }

                  var ordPWDs = StringToMd5(ordPWD);
                  var newPwds = StringToMd5(newPwd);

                  var params = {
                    "uid": userInfo.id,
                    "oldPWD": ordPWDs,
                    "newPWD": newPwds,
                  };
                  UpdatePwd(params).then((res) {
                    if (res.code == 1000) {
                      ShowToast("修改成功");
                      Navigator.of(context).pop();
                    } else {
                      ShowToast("修改失败，请联系客服");
                    }
                  });
                } else {
                  ShowToast("您填写的信息有误");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget renderCell(String imgUrl, String name, String desc, String btnTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.network(
              imgUrl,
              width: 20,
              height: 17,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(name,
                  style: TextStyle(
                      color: UIData.normal_font_color,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 20,
              width: 1,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(desc,
                  style: TextStyle(
                      color: UIData.normal_font_color,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ),
        Offstage(
          offstage: "" == btnTitle,
          child: Container(
            height: 28,
            width: 70,
            margin: EdgeInsets.only(right: 30),
            child: RaisedButton(
              child: new Text(btnTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              textTheme: ButtonTextTheme.normal,
              color: UIData.primary_color,
              onPressed: () {
                if (name == "登录密码") {
                  _showUpdatePwdDialog();
                  return;
                }
                _showDialog();
              }, //按钮的主题,
            ),
          ),
        )
      ],
    );
  }
}
