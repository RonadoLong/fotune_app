import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/FInputWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/page/login/ForgetPWDPage.dart';
import 'package:fotune_app/utils/MD5Utils.dart';
import 'package:fotune_app/utils/NavigatorUtils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:flustars/flustars.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 20.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  bool isLoading = false;
  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  var bus = new EventBus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("登录", context),
      body: new Container(
        child: new Center(
          //防止overFlow的现象
          child: SafeArea(
            child: SingleChildScrollView(
              child: new Padding(
                padding: new EdgeInsets.only(
                    left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomWidget.BuildLogImage(null),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new FInputWidget(
                      hintText: "手机号",
                      isNumber: true,
                      iconData: Icons.account_circle,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userNameController,
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new FInputWidget(
                      hintText: "密码",
                      iconData: Icons.security,
                      obscureText: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userPassController,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context, new MaterialPageRoute(builder: (context) => new ForgetPWDPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 40, top: 8),
                            child: Text("忘记密码?", textAlign: TextAlign.left, style: TextStyle(color: UIData.primary_color),),
                          )
                      ],),
                    ),
                    new Padding(padding: new EdgeInsets.all(30.0)),
                    new Container(
                      width: 360.0,
                      margin: new EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                      padding: new EdgeInsets.fromLTRB(leftRightPadding,
                          topBottomPadding, leftRightPadding, topBottomPadding),
                      child: new Card(
                        color: UIData.grey_color,
                        elevation: 6.0,
                        child: new FlatButton(
                            onPressed: () {
                              var phone = _userNameController.text.trim();
                              var password = _userPassController.text.trim();
                              if (phone.length < 11 || password.length == 0) {
                                ShowToast("完善信息");
                                return;
                              }

                              if (isLoading) {
                                ShowToast("登录中...");
                                return;
                              }

                              setState(() {
                                isLoading = !isLoading;
                              });
                              var pwd = StringToMd5(password);
                              var params = {
                                "username": phone,
                                "password": pwd,
                              };

                              Login(params).then((res) {
                                print(" login success ======== $res.code");
                                if (res.code == 1000) {
                                  SpUtil.putObject("userInfo", res.data)
                                      .then((val) {
                                    if (val) {
                                      ShowToast("登录成功");
                                      scheduleMicrotask((){
                                        bus.emit("login","");
                                      });
                                      Navigator.of(context).pop("登录成功");
                                    }
                                  });
                                } else {
                                  ShowToast("登录失败，请重试");
                                }
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              }).catchError((err) {
                                print(err);
                                ShowToast("登录失败，请重试");
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              });
                            },
                            child: new Padding(
                              padding: new EdgeInsets.all(6.0),
                              child: new Text(
                                '马上登录',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 6.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("还没账号?"),
                          new GestureDetector(
                            child: new Text(
                              "马上注册",
                              style: TextStyle(color: UIData.primary_color),
                            ),
                            onTap: () {
                              GotoRegisterPage(context);
                            },
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(30.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
