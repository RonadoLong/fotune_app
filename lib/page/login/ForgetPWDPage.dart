
import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/FInputWidget.dart';
import 'package:fotune_app/componets/LoginFormCode.dart';
import 'package:fotune_app/utils/MD5Utils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';


class ForgetPWDPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ForgetPWDPageState();
  }
}

class _ForgetPWDPageState extends State<ForgetPWDPage> {
  var leftRightPadding = 20.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 13.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 13.0, color: Colors.blueGrey);
  bool isCanGetCode = false;
  bool isLogin = false;

  var _userPassController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _codeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("忘记密码", context),
      body: new Container(
        child: new Center(
          //防止overFlow的现象
          child: SafeArea(
            child: SingleChildScrollView(
              child: new Padding(
                padding:
                    new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CustomWidget.BuildLogImage(null),
                    new Padding(padding: new EdgeInsets.all(20.0)),
                    new FInputWidget(
                      hintText: "手机号",
                      isNumber: true,
                      iconData: Icons.phone_locked,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _phoneController,
                    ),
                    new Padding(padding: new EdgeInsets.all(4.0)),
                    new FInputWidget(
                      hintText: "新密码",
                      iconData: Icons.security,
                      obscureText: true,
                      onChanged: (String value) {
                        print(value);
                      },
                      controller: _userPassController,
                    ),
                    new Padding(padding: new EdgeInsets.all(4.0)),
                    Container(
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: new FInputWidget(
                              hintText: "验证码",
                              iconData: Icons.verified_user,
                              obscureText: true,
                              onChanged: (String value) {
                                print(value);
                              },
                              controller: _codeController,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: LoginFormCode(
                              available:
                                  _phoneController.text.trim().length >= 11,
                              onTapCallback: () {
                                var phone = _phoneController.text.trim();
                                if (phone.length == 0 || phone.length < 11) {
                                  ShowToast("请填写正确的手机号");
                                  return;
                                }
                                GetCode(phone).then((res) {
                                  print("获取验证码 =========== $res");
                                  if (res.code == 1000) {
                                    ShowToast("获取成功");
                                  } else {
                                    ShowToast(res.msg);
                                  }
                                }).catchError((err) {
                                  print(err);
                                  ShowToast("获取失败，请重试");
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(20.0)),
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
                              var password = _userPassController.text.trim();
                              var phone = _phoneController.text.trim();
                              var code = _codeController.text.trim();

                              if (password.length == 0 || phone.length == 0 ) {
                                ShowToast("请完善信息");
                                return;
                              }
                              if (password.length < 6) {
                                ShowToast("密码不能少于6位数");
                                return;
                              }
                              var pwd = StringToMd5(password);
                              var params = {
                                "phone": phone,
                                "password": pwd,
                                "phoneCode": code,
                              };
                              if (isLogin) {
                                return;
                              }
                              setState(() {
                                isLogin = !isLogin;
                              });
                              ForgetPWD(params).then((res) {
                                print(res);
                                if (res.code == 1000) {
                                  ShowToast("修改成功，登录吧");
                                  Navigator.of(context).pop();
                                } else {
                                  ShowToast(res.msg);
                                }
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              }).catchError((err) {
                                print(err);
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              });
                            },
                            child: new Padding(
                              padding: new EdgeInsets.all(6.0),
                              child: new Text(
                                '重置密码',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )),
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
