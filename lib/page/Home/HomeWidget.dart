import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fotune_app/componets/carousel.dart';
import 'package:fotune_app/componets/cell.dart';
import 'package:fotune_app/page/Home/model/Carsousel.dart';
import 'package:fotune_app/page/Home/model/NiuPeople.dart';
import 'package:fotune_app/page/stock/model/StockIndex.dart';
import 'package:fotune_app/utils/ComstomBtnColumn.dart';
import 'package:fotune_app/utils/CustomQuoteCell.dart';
import 'package:fotune_app/utils/UIData.dart';

Widget newButtonSection(Function callBack) {
  return new Container(
    height: 80,
    color: Colors.white,
    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: (){
            callBack(1);
          },
          child: CustomBtnColumn(Icons.create_new_folder, '发布策略', null),
        ),
        GestureDetector(
          onTap: (){
            callBack(11);
          },
          child: CustomBtnColumn(Icons.account_balance_wallet, '即可充值', null),
        ),
        GestureDetector(
          onTap: (){
            callBack(2);
          },
          child: CustomBtnColumn(Icons.notifications_active, '股票策略', null),
        ),
        GestureDetector(
          onTap: (){
            callBack(12);
          },
          child: CustomBtnColumn(Icons.message, '新手指引', null),
        ),
      ],
    ),
  );
}

Container newCarousel(List<Carousel> _images) {
  if (_images.isEmpty) {
    return Container();
  }
  return new Container(
      height: 220.0,
      child: ListView(
        children: <Widget>[
          new Container(
            height: 220.0,
            child: SyCarousel(
              autoPlay: true,
              dotSize: 10.0,
              showIndicators: true,
              children: _images.map((item) {
                return Image.network(
                  item.url,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
          ),
          new SizedBox(
            height: 30.0,
          ),
        ],
      ));
}

Widget newQuoteView(List<StockIndex> markets) {
  return new Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 6),
      child: Column(
        children: <Widget>[
          SyCell(
            title: '指数行情',
            onTap: () {},
          ),
          new Column(
              children: markets.map((stockIndex) {
            String gains_rate = stockIndex.gains_rate;
            String change_prefix = "";

            return new CustomQuoteCell(
              Icons.account_circle,
              stockIndex.name,
              stockIndex.current_points,
              change_prefix + gains_rate + "%",
            );
          }).toList()),
        ],
      ));
}

Widget newNiuRenView(BuildContext context, List<NiuPeople> nius) {
  return new Container(
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 6),
    child: new Column(
      children: <Widget>[
        SyCell(
          title: '最牛达人',
        ),
        Column(
          children: nius.map((niu) {
            return buildNiuPeopleCell(niu);
          }).toList(),
        )
      ],
    ),
  );
}

getNiuImage(String imgUrl) {
  return new CachedNetworkImage(
    imageUrl: imgUrl,
    errorWidget: new Icon(Icons.error),
    fit: BoxFit.cover,
    height: 40.0,
    width: 40.0,
  );
}

Widget buildNiuPeopleCell(NiuPeople niu) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: getNiuImage(
                  "http://gp.axinmama.com/public/static/home/img/moblie/default-user-img5.png"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
            ),
            Text(niu.name),
            Padding(
              padding: EdgeInsets.only(top: 4),
            ),
            CachedNetworkImage(
              imageUrl:
                  "http://gp.axinmama.com/public/static/home/img/moblie/icon_nr@2x4.png",
              errorWidget: new Icon(Icons.error),
              fit: BoxFit.cover,
              height: 16.0,
              width: 30.0,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text("策略数: " + niu.strategyCount.toString()),
            ),
            Container(
              child: Text("胜算率: " + niu.winRate),
            ),
            Container(
              child: Text("收益率: " + niu.returnRate),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          height: 1,
          color: Colors.black12,
        )
      ],
    ),
  );
}

getImage(String imgUrl) {
  return new CachedNetworkImage(
    imageUrl: imgUrl,
    errorWidget: new Icon(Icons.error),
    fit: BoxFit.cover,
    height: 85.0,
    width: 110.0,
  );
}
