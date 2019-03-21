import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/cell.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Profile/MineWidget.dart';
import 'package:fotune_app/page/Profile/SettingPage.dart';
import 'package:fotune_app/page/login/LoginPage.dart';
import 'package:fotune_app/utils/NavigatorUtils.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MinePageState();
}

class MinePageState extends State<MinePage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  List<String> titles = [
    "",
    "审核充值",
//    "我的推广",
//    "个人资料",
    "银行卡管理",
    "资金明细",
    "我的持仓",
    "历史交易"
  ];
  List<IconData> icons = [
    Icons.assignment,
//    Icons.all_inclusive,
//    Icons.supervisor_account,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.account_circle,
    Icons.data_usage,
  ];
//  var userAvatar = "https://image.showm.xin/wb/user/profile.jpg";
  var userAvatar =
      "http://gp.axinmama.com/public/static/home/img/moblie/default-user-img5.png";

//http://gp.axinmama.com/public/static/home/img/moblie/default-user-img5.png
//  https://image.showm.xin/wb/user/ic_avatar_default.png
  UserInfo user = new UserInfo();

  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      loadUserInfo();
    });
  }

  void loadUserInfo() {
    User userinfo = GetLocalUser();
    if (userinfo == null) {
      return;
    }
    GetUserInfo(userinfo.user_id).then((res) {
      if (res.code == 1000) {
        setState(() {
          user = res.data;
        });
      } else {
        ShowToast("加载数据失败，请重试");
        setState(() {
          user = null;
        });
      }
    }).catchError((err) {
      ShowToast("未知错误，请重试");
    });
  }

  Widget getIconImage(path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: new Image.asset(path,
          width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  @override
  Widget build(BuildContext context) {
    var name = user != null ? user.userName : null;
    var amount = user != null ? user.amount : null;

    var listView = RefreshIndicator(
      onRefresh: (() => _handleRefresh()),
      color: UIData.refresh_color, //刷新控件的颜色
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, idx) {
          return Container(
            height: 2,
            color: Color.fromARGB(50, 183, 187, 197),
          );
        },
        itemCount: titles.length,
        itemBuilder: (context, i) => renderRow(i, userAvatar, name, amount,
            titles, icons, context, _handleRefresh),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "我的",
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: UIData.primary_color,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SettingPage()))
                      .then((result) {
                    if (result != null) {
                      user = null;
                    }
                  });
                } else {
                  GotoLoginPage(context).then((res) {
                    if (res != null) {
                      _handleRefresh();
                    }
                  });
                }
              }),
        ],
      ),
      body: listView,
    );
  }
}
