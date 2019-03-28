import 'package:flutter/material.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/Chongzhi.dart';
import 'package:fotune_app/page/Profile/model/RechargeLists.dart';
import 'package:fotune_app/utils/UIData.dart';

class ChongZhiPage extends StatefulWidget {
  @override
  State createState() {
    return ChongZhiPageState();
  }
}

class ChongZhiPageState extends State<ChongZhiPage> {
  List<ChongzhiResp> datas = [
    ChongzhiResp("http://gp.axinmama.com/public/static/home/img/moblie/yl.png",
        "银行转账", "快速安全，24小时支付"),
    ChongzhiResp("http://gp.axinmama.com/public/static/home/img/moblie/zfb.png",
        "支付宝支付", "快速安全，24小时支付"),
    ChongzhiResp("http://gp.axinmama.com/public/static/home/img/moblie/wx.png",
        "微信支付", "快速安全，24小时支付"),
  ];

  List<Recharge> recharges = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    GetRechargeLists().then((res) {
      if (res.code == 1000) {
        if (res.data != null) {
          setState(() {
            res.data.forEach((v) {
              recharges.add(Recharge.fromJson(v));
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar("充值", context),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return renderRow(index);
          },
          separatorBuilder: (context, idx) {
            return Container(
              height: 5,
            );
          },
          itemCount: datas.length + 1),
    );
  }

  renderRow(index) {
    if (index == 0) {
      return Container(
        height: 40,
        padding: EdgeInsets.all(10),
        child: Text(
          "选择充值方式",
          textAlign: TextAlign.left,
        ),
      );
    } else {
      ChongzhiResp chongzhiResp = datas[index - 1];
      return Container(
        color: Colors.white,
        height: 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: 64,
              width: 84,
              child: Image.network(chongzhiResp.imgUrl),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chongzhiResp.title,
                  style: TextStyle(
                      color: UIData.normal_font_color,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  chongzhiResp.desc,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}
