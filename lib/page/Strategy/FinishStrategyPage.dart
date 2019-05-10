import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/Strategy/model/FinishStrategyResp.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:date_format/date_format.dart';

class FinishStrategyPage extends StatefulWidget {
  String title;
  FinishStrategyPage(title) {
    this.title = title;
  }
  @override
  State createState() {
    return FinishStrategyPageState();
  }
}

class FinishStrategyPageState extends State<FinishStrategyPage>
    with AutomaticKeepAliveClientMixin {
  @protected
  final ScrollController scrollController = new ScrollController();

  User user;
  List<CloseStrategys> dataList;
  int pageNum = 1;
  int pageSize = 10;
  // 默认不显示加载更多
  bool isShowMore = true;
  var bus = new EventBus();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (dataList.length >= pageSize) {
          print("load more data ========== ${(dataList.length >= pageSize)}");
          setState(() {
            isShowMore = false;
          });
          loadData(LOADMORE_REQIEST);
        }
      }
    });

    loadData(START_REQUEST);

    // 监听登录事件
    bus.on("login", (arg) {
      loadData(REFRESH_REQIEST);
    });

    bus.on("logout", (arg) {
      loadData(REFRESH_REQIEST);
    });
  }

  loadData(int type) {
    User user = GetLocalUser();
    if (user != null) {
      var currentPage = type == REFRESH_REQIEST ? 1 : pageNum + 1;
      GetCloseList(user.user_id, currentPage, pageSize).then((res) {
        if (res.code == 1000) {
          if (this.mounted) {
            setState(() {
              if (type == LOADMORE_REQIEST) {
                dataList.addAll(res.data.strategys);
              } else {
                dataList = res.data.strategys;
              }
              pageNum = currentPage;
            });
          }
        } else if (res.code == 1004) {
          if (type == LOADMORE_REQIEST) {
          } else {
            if (this.mounted) {
              setState(() {
                dataList = dataList == null ? [] : dataList;
              });
            }
          }
        }
        handleRefresh(() {
          setState(() {
            isShowMore = true;
          });
        });
      }).catchError((err) {
        print(err);
        if (this.mounted) {
          setState(() {
            isShowMore = false;
            dataList = [];
          });
        }
      });
    } else {
      if (this.mounted) {
        setState(() {
          dataList = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: widget.title == ""
          ? null
          : CustomWidget.BuildAppBar(widget.title, context),
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
        onRefresh: (() => handleRefresh(loadData(REFRESH_REQIEST))),
        color: UIData.refresh_color, //刷新控件的颜色
        child: ListView.separated(
          controller: scrollController,
          itemCount: dataList.length + 1,
          itemBuilder: (context, index) {
            if (dataList.length == 0) {
              return buildEmptyView();
            }
            if (index < dataList.length) {
              CloseStrategys cs = dataList[index];
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

  Widget buildBodyCell(CloseStrategys cs, int index) {
    Color color =
        cs.detail.tranProfit.indexOf("-") != -1 ? Colors.green : Colors.red;

    DateTime buyTime = DateTime.parse(cs.detail.buyTime);
    String buyTimeStr = formatDate(buyTime.add(Duration(hours: 8)),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

    DateTime sellTime = DateTime.parse(cs.detail.sellTime);
    String sellTimeStr = formatDate(sellTime.add(Duration(hours: 8)),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

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
                      cs.profit.toString() + " 元",
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

  @override
  bool get wantKeepAlive => true;
}
