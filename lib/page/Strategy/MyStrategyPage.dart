import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/Strategy/model/StrategyResp.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class MyStrategyPage extends StatefulWidget {
  @override
  State createState() {
    return MyStrategyPageState();
  }
}

class MyStrategyPageState extends State<MyStrategyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Strategy> strategyList;
  final ScrollController _scrollController = new ScrollController();
  User user;
  int pageNum = 0;
  int pageSize = 10;
  bool isShowMore = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loadData(START_REQUEST);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (strategyList.length >= pageSize) {
          setState(() {
            isShowMore = false;
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

  loadData(int reqType) {
    User user = GetLocalUser();
    print(" ===== GetStrategyList $user");
    if (user == null) {
      setState(() {
        strategyList = [];
      });
    } else {
      var currenPage = reqType == REFRESH_REQIEST ? 1 : pageNum + 1;
      GetStrategyList(user.user_id, currenPage, pageSize).then((res) {
        setState(() {
            isShowMore = true;
        });
        if (res.code == 1000) {
          setState(() {
            if (reqType == LOADMORE_REQIEST) {
              strategyList.addAll(res.data.myStrategy);
            } else {
              strategyList = res.data.myStrategy;
            }
            pageNum = currenPage;
          });
        } else if (res.code == 1004) {
          setState(() {
            strategyList = strategyList == null ? [] : strategyList;
          });
        }
      }).catchError((err){
        print(err);
        setState(() {
          isShowMore = true;
          strategyList = [];
        });
      });
    }
  }

  Widget buildBody() {
    if (strategyList == null) {
      return CircularProgressIndicator(
        backgroundColor: UIData.refresh_color,
      );
    }  else {
      return new RefreshIndicator(
          onRefresh: (() => _handleRefresh()),
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
                    return Offstage(offstage: isShowMore, child: BuildLoadMoreView());
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
    super.build(context);//必须添加
    return Scaffold(
      body: Center(
        child: buildBody(),
      ),
    );
  }

  buildListView(BuildContext context, Strategy strategy) {
    var code = strategy.stockCode;
    var buyAmount = strategy.amount;
    var stockCount = strategy.count;

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
                      print("=======================");
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
                            color: strategy.profit.toString().indexOf("-") != -1 ? Colors.green: Colors.red,
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
                      ShellStrategy(strategy);
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
                  buildCell("买入时间", strategy.Detail.buyTime),
                  buildCell("交易单号", strategy.Detail.orderNo),
                  buildCell("保证金", (strategy.Detail.creditAmount).toString() + "元"),
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
                                    color: strategy.profit.toString().indexOf("-") != -1 ? Colors.green: Colors.red,
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

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      loadData(REFRESH_REQIEST);
    });
  }

  // ignore: non_constant_identifier_names
  void ShellStrategy(Strategy strategy) {
    DateTime dateTime = DateTime.parse(strategy.Detail.buyTime);
    print(DateTime.now().day);
    if (DateTime.now().day == dateTime.day && DateTime.now().month == dateTime.month) {
      ShowToast("当天买入的股票下个工作日才能交易");
      return;
    }
    this._showDialog(strategy);
  }

  void _showDialog(Strategy strategy) {

    DateTime dateTime = DateTime.parse(strategy.Detail.buyTime);
    String dateStr =
    formatDate(dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);

    var content = Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("交易品种: " + strategy.stockName + "(" + strategy.stockCode + ")"),
          Text("卖出数量: " + strategy.count.toString() + "手"),
          Text("买入时间: " + dateStr ),
          Text("浮动盈亏: " + strategy.profit.toString()+ " (仅供参考)"),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("确认卖出？"),
          content: content,
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消", style: TextStyle(color: Colors.white),),
              color: UIData.normal_font_color,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("确认",style: TextStyle(color: Colors.white),),
              color: UIData.primary_color,
              onPressed: () {
                if (loading) return;
                setState(() {
                  loading = true;
                });
                User user = GetLocalUser();
                var query = {
                  "uid": user.user_id,
                  "strategyID": strategy.Detail.orderNo,
                  "closeType": 1,
                };
                QueryShellStrategy(query).then((res) {
                  setState(() {
                    loading = false;
                  });
                  if (res.code == 1000) {
                    ShowToast("卖出成功");
                    loadData(REFRESH_REQIEST);
                    Navigator.of(context).pop();
                  } else {
                    ShowToast(res.msg);
                  }
                }).catchError((err) {
                  print(err);
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  //显示对话框 添加策略
  void showMyDialogWithStateBuilder(BuildContext context, String id) {
    var phoneController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
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
                  if (loading) return;
                  setState(() {
                    loading = true;
                  });
                  var price = phoneController.text.trim();
                  if (price.length == 0) {
                    ShowToast("请输入您要追加的金额");
                    return;
                  }
                  print(phoneController.text);
                  var req = {
                    "uid": user.user_id,
                    "strategyId": id,
                    "creditAmount": double.parse(phoneController.text)
                  };
                  AddCredit(req).then((res){
                    setState(() {
                      loading = false;
                    });
                    if (res.code == 1000) {
                      ShowToast("追加成功");
                      Navigator.of(context).pop();
                    }else {
                      ShowToast("操作失败");
                    }
                  }).catchError((err) {
                    setState(() {
                      loading = false;
                    });
                  });
                },
              ),
            ],
          );
        });
  }
}
