import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/Strategy/model/StrategyResp.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/page/common/EventBus.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class MyStrategyPage extends StatefulWidget {
  String title;
  MyStrategyPage(title) {
    this.title = title;
  }

  @override
  State createState() {
    return MyStrategyPageState();
  }
}

class MyStrategyPageState extends State<MyStrategyPage> {
  // @override
  // bool get wantKeepAlive => true;

  List<Strategy> strategyList;

  @protected
  final ScrollController _scrollController = new ScrollController();

  User user;
  int pageNum = 0;
  int pageSize = 10;
  bool isShowMore = true;
  bool loading = false;

  @protected
  var bus = new EventBus();

  @override
  void initState() {
    super.initState();

    loadData(START_REQUEST);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (strategyList.length >= pageSize) {
          if (this.mounted) {
            setState(() {
              isShowMore = false;
            });
          }
        }
        loadData(LOADMORE_REQIEST);
      }
    });

    // 监听登录事件
    bus.on("login", (arg) {
      loadData(REFRESH_REQIEST);
    });

    bus.on("logout", (arg) {
      loadData(REFRESH_REQIEST);
    });

    bus.on("refreshMineStrategyData", (arg) {
      print("refreshMineStrategyData");
      loadData(REFRESH_REQIEST);
    });
  }

  loadData(int reqType) {
    User user = GetLocalUser();
    if (user == null) {
      if (this.mounted) {
        setState(() {
          strategyList = [];
        });
      }
    } else {
      var currenPage = reqType == REFRESH_REQIEST ? 1 : pageNum + 1;
      GetStrategyList(user.user_id, currenPage, pageSize).then((res) {
        if (res.code == 1000) {
          if (this.mounted) {
            setState(() {
              if (reqType == LOADMORE_REQIEST) {
                strategyList.addAll(res.data.myStrategy);
              } else {
                strategyList = res.data.myStrategy;
              }
              pageNum = currenPage;
            });
          }
        } else if (res.code == 1004) {
          if (this.mounted) {
            setState(() {
              strategyList = strategyList == null ? [] : strategyList;
            });
          }
        }
        handleRefresh(() {
          if (this.mounted) {
            setState(() {
              isShowMore = true;
            });
          }
        });
      }).catchError((err) {
        print(err);
        if (this.mounted) {
          setState(() {
            isShowMore = true;
            strategyList = [];
          });
        }
      });
    }
  }

  Widget buildBody() {
    if (strategyList == null) {
      return CircularProgressIndicator(
        backgroundColor: UIData.refresh_color,
      );
    } else {
      return new RefreshIndicator(
          onRefresh: (() => handleRefresh(loadData(REFRESH_REQIEST))),
          color: UIData.refresh_color, //刷新控件的颜色
          child: ListView.separated(
            itemCount: strategyList.length + 1,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (strategyList.length == 0) {
                return buildEmptyView();
              } else {
                if (index < strategyList.length) {
                  Strategy strategy = strategyList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: buildListView(context, strategy),
                  );
                } else {
                  return Offstage(
                      offstage: isShowMore, child: BuildLoadMoreView());
                }
              }
            },
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, idx) {
              return Container(
                height: 5,
                color: Color.fromARGB(50, 183, 187, 197),
              );
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: widget.title == ""
          ? null
          : CustomWidget.BuildAppBar(widget.title, context),
      body: Center(
        child: buildBody(),
      ),
    );
  }

  buildListView(BuildContext context, Strategy strategy) {
    var code = strategy.stockCode;
    var buyAmount = strategy.amount;
    var stockCount = strategy.count;

    DateTime dateTime = DateTime.parse(strategy.Detail.buyTime);

    String dateStr = formatDate(dateTime.add(Duration(hours: 8)),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(strategy.stockName,
                                style: TextStyle(
                                    color: UIData.normal_font_color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(' ($code)',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          Text(" 金额：$buyAmount元",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          Text(" $stockCount股(可用)",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      List<Strategy> ss = [];
                      strategyList.forEach((s) {
                        if (s.Detail.orderNo == strategy.Detail.orderNo) {
                          s.isShow = !s.isShow;
                        } else {
                          s.isShow = true;
                        }
                        ss.add(s);
                      });
                      setState(() {
                        strategyList = ss;
                      });
                    },
                    child: Text(
                      "查看细节",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1,
            color: Colors.black12,
          ),
          Container(
            margin: EdgeInsets.all(15),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(strategy.buyPrice),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(strategy.localPrice),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        strategy.profit.toString(),
                        style: TextStyle(
                            color: strategy.profit.toString().indexOf("-") != -1
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
                ),
                ButtonTheme(
                  buttonColor: Colors.red,
                  minWidth: 60.0,
                  height: 30.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    onPressed: () {
                      _ShellStrategy(strategy);
                    },
                    highlightColor: UIData.primary_color,
                    child: Text("卖出"),
                  ),
                )
              ],
            ),
          ),
          Offstage(
            offstage: strategy.isShow,
            child: Container(
              color: Colors.black12,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildCell("买入时间", dateStr),
                  buildCell("交易单号", strategy.Detail.orderNo),
                  buildCell(
                      "保证金", (strategy.Detail.creditAmount).toString() + "元"),
                  buildCell("止损线", strategy.Detail.stopLoss.toString() + "元"),
                  buildCell("浮动赢亏比", strategy.Detail.floatProfit.toString()),
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
                                "浮动盈亏",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " " + strategy.profit.toString(),
                                style: TextStyle(
                                    color: strategy.profit
                                                .toString()
                                                .indexOf("-") !=
                                            -1
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: ButtonTheme(
                            buttonColor: UIData.primary_color,
                            minWidth: 100.0,
                            height: 30.0,
                            child: RaisedButton(
                              onPressed: () {
                                showMyDialogWithStateBuilder(
                                    context, strategy.Detail.orderNo);
                              },
                              child: Text(
                                "追加保证金",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCell(String title, String time) {
    return Container(
      padding: EdgeInsets.all(10),
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
            margin: EdgeInsets.only(top: 10),
            height: 0.5,
            color: Colors.black26,
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _ShellStrategy(Strategy strategy) {
    DateTime dateTime = DateTime.parse(strategy.Detail.buyTime);
    if (DateTime.now().day == dateTime.day &&
        DateTime.now().month == dateTime.month) {
      ShowToast("当天买入的股票下个工作日才能交易");
      return;
    }
    this.ShowSellDialog(strategy);
  }

  void ShowSellDialog(Strategy strategy) {
    DateTime dateTime = DateTime.parse(strategy.Detail.buyTime);
    String dateStr = formatDate(dateTime.add(Duration(hours: 8)),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("确认卖出？"),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            var pushing = false;
            return Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("交易品种: " +
                      strategy.stockName +
                      "(" +
                      strategy.stockCode +
                      ")"),
                  Text("卖出数量: " + strategy.count.toString() + "股"),
                  Text("买入时间: " + dateStr),
                  Text("浮动盈亏: " + strategy.profit.toString() + " (仅供参考)"),
                  pushing
                      ? Container(
                          margin: EdgeInsets.only(top: 18),
                          width: 60.0,
                          height: 60.0,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                              color: UIData.primary_color,
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(30.0))),
                          child: new CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : buildBottom(context, pushing, strategy)
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget buildBottom(context, bool pushing, Strategy strategy) {
    return Container(
      height: 44,
      width: 100,
      margin: EdgeInsets.only(top: 20),
      child: new RaisedButton(
        child: new Text(
          "确认",
          style: TextStyle(color: Colors.white),
        ),
        color: UIData.primary_color,
        onPressed: () {
          if (pushing) return;
          pushing = true;
          User user = GetLocalUser();
          var query = {
            "uid": user.user_id,
            "strategyID": strategy.Detail.orderNo,
            "closeType": 1,
          };
          QueryShellStrategy(query).then((res) {
            pushing = false;
            if (res.code == 1000) {
              ShowToast("卖出成功");
              loadData(REFRESH_REQIEST);
              Navigator.of(context).pop();
            } else {
              ShowToast(res.msg);
            }
          }).catchError((err) {
            ShowToast("网络出错，请联系管理员");
            pushing = false;
          });
        },
      ),
    );
  }

  //显示对话框 添加策略
  void showMyDialogWithStateBuilder(BuildContext context, String id) {
    var phoneController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          var pushing = false;
          return new AlertDialog(
            title: Text(
              "输入追加金额",
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: 100,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("单号: " + id),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                      ),
                    ],
                  ),
                ),
              );
            }),
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
                  if (pushing) return;
                  pushing = true;
                  var price = phoneController.text.trim();
                  if (price.length == 0) {
                    ShowToast("请输入您要追加的金额");
                    return;
                  }
                  User user = GetLocalUser();
                  var req = {
                    "uid": user.user_id,
                    "strategyId": id,
                    "creditAmount": double.parse(phoneController.text)
                  };
                  AddCredit(req).then((res) {
                    pushing = false;
                    if (res.code == 1000) {
                      ShowToast("追加成功");
                      Navigator.of(context).pop();
                    } else {
                      ShowToast("操作失败");
                    }
                  }).catchError((err) {
                    pushing = false;
                  });
                },
              ),
            ],
          );
        });
  }
}
