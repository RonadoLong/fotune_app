import 'package:flutter/material.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/componets/cell.dart';
import 'package:fotune_app/model/UserInfo.dart';
import 'package:fotune_app/page/Profile/BankPages.dart';
import 'package:fotune_app/page/Profile/ChongZhiPage.dart';
import 'package:fotune_app/page/Profile/FundDetailsParentsPage.dart';
import 'package:fotune_app/page/Profile/TiXianPage.dart';
import 'package:fotune_app/page/Strategy/StrategyPage.dart';
import 'package:fotune_app/utils/ComstomBtnColumn.dart';
import 'package:fotune_app/utils/NavigatorUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

renderRow(
    var i,
    String userAvatar,
    String userName,
    var price,
    UserInfo user,
    List<String> cellTitle,
    List<IconData> cellIcon,
    BuildContext context,
    Function handleRefresh) {
  if (i == 0) {
    var avatarContainer = new Container(
      color: UIData.primary_color,
      height: 200.0,
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    child: CustomBtnColumn(
                        Icons.account_balance, '充值', Colors.white),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ChongZhiPage()));
                    },
                  ),
                ),
                GestureDetector(
                  child: CustomWidget.BuildLogImage(userAvatar),
                  onTap: () {
                    if (userName == null) {
                      GotoLoginPage(context).then((res) {
                        if (res != null || res != "") {
                          handleRefresh();
                        }
                      });
                    }
                  },
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      child: CustomBtnColumn(
                          Icons.account_balance_wallet, '提现', Colors.white),
                      onTap: () {
                        print("======");
                        Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new TiXianPage(user)))
                            .then((res) {
                          handleRefresh();
                        });
                      },
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: GestureDetector(
                child: Text(
                  userName == null ? "点击头像登录" : userName,
                  style: new TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                onTap: () {
                  if (userName == null) {
                    GotoLoginPage(context).then((res) {
                      if (res != null || res != "") {
                        handleRefresh();
                      }
                    });
                  }
                },
              ),
            ),
            Container(
              height: 20,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                price == null ? "账户余额: 0元" : "账户余额: $price元",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12.0, color: UIData.normal_font_color),
              ),
            ),
          ],
        ),
      ),
    );
    return avatarContainer;
  }

  return SyCell(
    title: cellTitle[i],
    icon: Icon(cellIcon[i - 1]),
    onTap: () {
      if (userName == null) {
        GotoLoginPage(context).then((res) {
          if (res != null || res != "") {
            handleRefresh();
          }
        });
        return;
      }
      switch (i) {
        case 1:
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new ChongZhiPage()));
          break;
        case 2:
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new BankPage(user)));
          break;
        case 3:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new FundDetailsParentsPage()));
          break;
        case 4:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new StrategyPage(cellTitle[i])));
          break;
        case 5:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new StrategyPage(cellTitle[i])));
          break;
      }
    },
  );
}
