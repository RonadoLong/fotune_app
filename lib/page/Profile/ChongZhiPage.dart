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
    this.loadData();
  }

  loadData() {
    GetRechargeLists().then((res) {
      if (res.code == 1000) {
        if (res.data != null) {
          setState(() {
            res.data.forEach((v) {
              recharges.add(Recharge.fromJson(v));
            });
            print(res.data);
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
          itemCount: recharges.length + 1),
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
      // 0-银行卡;1-微信;2-支付宝
      Recharge recharge = recharges[index - 1];
      String name = "";
      String imgUrl = "";

      if (recharge.type == 0) {
        name = "银行卡";
        imgUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564124712778&di=0715bd70bb3d5732d7c1c2086cf3b5f0&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20180623%2F0291d529afa3438e9b6c59364be96bcc.jpeg";
      } else if (recharge.type == 1) {
        // name = "微信";
        // imgUrl = "http://gp.axinmama.com/public/static/home/img/moblie/wx.png";
        name = "银联";
        imgUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564124712778&di=0715bd70bb3d5732d7c1c2086cf3b5f0&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20180623%2F0291d529afa3438e9b6c59364be96bcc.jpeg";
      } else {
        name = "支付宝";
        imgUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564124830399&di=910db4851e6f6ddc730f525d9831c02b&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170703%2F2b4d688817e74dd9af3c720c5d9b4473_th.jpg";
      }
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChongzhiDetail(name, recharge)));
        },
        child: Container(
          color: Colors.white,
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                height: 64,
                width: 84,
                child: Image.network(imgUrl),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: UIData.normal_font_color,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "快速安全，24小时支付",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}

class ChongzhiDetail extends StatelessWidget {
  String title;
  Recharge recharge;
  ChongzhiDetail(String title, Recharge recharge) {
    this.title = title;
    this.recharge = recharge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.BuildAppBar(title, context),
      body: buildCard(),
    );
  }

  Widget buildCard() {
    // 0-银行卡;1-微信;2-支付宝
    if (recharge.type == 0) {
      return Container(
        margin: EdgeInsets.all(8),
        height: 300,
        child: Card(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(" 账号: " + recharge.cardNumber),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                  ),
                  Text(" 姓名: " + recharge.userName),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                  ),
                  Text(" 开户行: ${recharge.bankName}"),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                  ),
                  Text(" " + recharge.desc)
                ],
              ),
            )),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("请用${title}扫描二维码"),
              Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              Container(
                height: 250,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.network(
                      recharge.qRCodeURL,
                      width: 250,
                      height: 250,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              Text(
                "请扫码充值，并务必在转账备注中填写注册手机号，这样方便我们多重信息确认您的汇款。",
                style: TextStyle(color: Colors.red),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
              ),
              Text(recharge.desc),
            ]),
      );
    }
  }
}
