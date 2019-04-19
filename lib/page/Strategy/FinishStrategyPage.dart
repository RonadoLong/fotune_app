import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/Strategy/model/FinishStrategyResp.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:date_format/date_format.dart';

class FinishStrategyPage extends StatefulWidget {

  String title;
  FinishStrategyPage(title){
    this.title = title;
  }

  @override
  State createState() {
    return FinishStrategyPageState();
  }
}

class FinishStrategyPageState extends State<FinishStrategyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = new ScrollController();
  User user;
  List<CloseStrategys> dataList;
  int pageNum = 1;
  int pageSize = 10;
  bool isShowMore = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = GetLocalUser();
      loadData(START_REQUEST);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (dataList.length >= 10) {
          setState(() {
            isShowMore = true;
          });
        }
        loadData(LOADMORE_REQIEST);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  loadData(int type) {
    if (user != null) {
      var currentPage = type == REFRESH_REQIEST ? 1 : pageNum + 1;
      GetCloseList(user.user_id, pageNum, pageSize).then((res) {
        setState(() {
          isShowMore = false;
        });

        if (res.code == 1000) {
          setState(() {
            if (type == LOADMORE_REQIEST) {
              isShowMore = false;
              dataList.addAll(res.data.strategys);
            } else {
              dataList = res.data.strategys;
            }
            pageNum = currentPage;
          });
        } else if (res.code == 1004) {
          if (type == LOADMORE_REQIEST) {
          } else {
            setState(() {
              dataList = dataList == null ? [] : dataList;
            });
          }
        }
      }).catchError((err) {
        print(err);
        setState(() {
          isShowMore = false;
          dataList = [];
        });
      });
    } else {
      print("用户为登录");
      setState(() {
        dataList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //必须添加
    return Scaffold(
      appBar: widget.title == "" ? null : CustomWidget.BuildAppBar(widget.title, context),
      body: Center(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (dataList == null) {
      return CircularProgressIndicator(
        backgroundColor: UIData.refresh_color,
      );
    } else {
      return new RefreshIndicator(
        onRefresh: (() => _handleRefresh()),
        color: UIData.refresh_color, //刷新控件的颜色
        child: ListView.separated(
          itemCount: dataList.length >= pageSize || dataList.length == 0
              ? dataList.length + 1
              : dataList.length,
          itemBuilder: (context, index) {
            if (dataList.length == 0) {
              return buildEmptyView();
            }
            CloseStrategys cs = dataList[index];
            if (index < dataList.length) {
              return buildBodyCell(cs, index);
            } else {
              return Offstage(offstage: isShowMore, child: BuildLoadMoreView());
            }
          },
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, idx) {
            return Container(
              height: 5,
              color: Color.fromARGB(50, 183, 187, 197),
            );
          },
        ),
      );
    }
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      loadData(REFRESH_REQIEST);
    });
  }

  Widget buildBodyCell(CloseStrategys cs, int index) {
    Color color = cs.detail.tranProfit.indexOf("-") != -1 ? Colors.green : Colors.red;

    DateTime buyTime = DateTime.parse(cs.detail.buyTime);
    String buyTimeStr = formatDate(buyTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

    DateTime sellTime = DateTime.parse(cs.detail.sellTime);
    String sellTimeStr = formatDate(sellTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          cs.stockName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                        ),
                        Text(" (" + cs.stockCode + ")"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(cs.sellTime.substring(0, 10)),
                        Padding(
                          padding: EdgeInsets.all(4),
                        ),
                        GestureDetector(
                          onTap: () {
                            cs.isShow = !cs.isShow;
                            setState(() {
                              dataList[index] = cs;
                            });
                          },
                          child: Text(
                            "查看详情",
                            style: TextStyle(color: UIData.primary_color),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("交易赢亏"),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      cs.detail.buyPrice.toString() + " 元",
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
              ],
            ),
            Offstage(
              offstage: cs.isShow,
              child: GestureDetector(
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    children: <Widget>[
                      buildCell("交易单号", cs.id),
                      buildCell("交易本金", cs.detail.tranAmount.toString()),
                      buildCell("买入时间", buyTimeStr),
                      buildCell("买入类型", cs.detail.buyType),
                      buildCell("买入价格", cs.detail.buyPrice.toString() + '元'),
                      buildCell("卖出时间", sellTimeStr),
                      buildCell("卖出价格", cs.detail.sellPrice.toString() + '元'),
                      buildCell("建仓费", cs.detail.buildingFee.toString() + '元'),
                      buildCell("平仓费", cs.detail.closingFee.toString() + '元'),
                      buildCell("递延费", cs.detail.deferredFee.toString() + '元'),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(6),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    cs.detail.tranProfit,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Text(
                                    cs.detail.handleFee,
                                    style: TextStyle(
                                        color: UIData.primary_color,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildCell(String title, String time) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title),
              Text(time),
            ],
          ),
          Container(
            height: 0.5,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}
