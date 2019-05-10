import 'package:flutter/material.dart';
import 'package:fotune_app/api/strategy.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/componets/CustomAppBar.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/stock/model/SearchResp.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class StockSearchPage extends StatefulWidget {
  bool isCall;
  StockSearchPage(this.isCall);

  @override
  State<StatefulWidget> createState() {
    return StockSearchPageState();
  }
}

class StockSearchPageState extends State<StockSearchPage> {
  List<SearchStock> list = [];
  String key = "";
  bool pushing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearch(),
        backgroundColor: UIData.primary_color,
      ),
      body: ListView.builder(
          itemCount: list.length,
          padding: new EdgeInsets.all(20.0),
          itemBuilder: (BuildContext context, int index) {
            SearchStock s = list[index];
            return GestureDetector(
                onTap: () {
                  if (widget.isCall) {
                    var code = s.market + s.code;
                    Navigator.of(context).pop(code);
                    return;
                  }

                  if (this.pushing) {
                    ShowToast("正在处理中...");
                    return;
                  }

                  setState(() {
                    this.pushing = true;
                  });

                  User user = GetLocalUser();
                  if (user != null) {
                    var query = {
                      "userId": user.user_id,
                      "code": s.code,
                      "name": s.name
                    };
                    AddStock(query).then((res) {
                      setState(() {
                        this.pushing = false;
                      });
                      if (res.code == 1000) {
                        ShowToast("已添加到自选");
                        setState(() {
                          list = [];
                        });
                      } else {
                        ShowToast(res.msg);
                      }
                    }).catchError((err) {
                      setState(() {
                        this.pushing = false;
                      });
//                          ShowToast("网络出错");
                    });
                  }
                },
                child: Container(
                  height: 50,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(s.code),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          Text(s.name),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                        height: 0.5,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  loadData(query) {
    GetStockList(query).then((res) {
      if (res.code == 1000) {
        ShowToast("查询成功");
        setState(() {
          list = res.data;
        });
      } else {
        ShowToast("没有找到数据");
      }
    }).catchError((err) {
//      ShowToast("网络出错");
    });
  }

  Widget buildSearch() {
    return Container(
      height: 70.0,
      child: Card(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: UIData.normal_font_color,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: new InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  hintText: '请输入股票名称/代码/简拼',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    key = val.trim();
                  });
                },
              ),
              flex: 1,
            ),
            IconButton(
              icon: Icon(Icons.send, color: UIData.normal_font_color),
              onPressed: () {
                if (key.length == 0) {
                  ShowToast("请输入要查找的信息");
                  return;
                }
                loadData(key);
              },
            )
          ],
        ),
      ),
    );
  }
}
