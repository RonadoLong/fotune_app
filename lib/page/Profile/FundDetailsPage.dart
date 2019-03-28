import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fotune_app/api/account.dart';
import 'package:fotune_app/api/user.dart';
import 'package:fotune_app/model/User.dart';
import 'package:fotune_app/page/Profile/model/FoundDetailResp.dart';
import 'package:fotune_app/utils/UIData.dart';
import 'package:loadmore/loadmore.dart';
import 'package:date_format/date_format.dart';

class FundDetailsPage extends StatefulWidget {
  int index;

  FundDetailsPage(this.index);

  @override
  State createState() {
    return FundDetailsPageState();
  }
}

class FundDetailsPageState extends State<FundDetailsPage> {
  User user;
  List<FoundDetails> dataList;
  int pageNum = 1;
  int pageSize = 20;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    if (user == null) {
      setState(() {
        user = GetLocalUser();
        loadDetail(user.user_id);
      });
    } else {
      loadDetail(user.user_id);
    }
  }

  loadDetail(String userId) {
    GetUserFundDetails(userId, widget.index, pageNum, pageSize).then((res) {
      if (res.code == 1000) {
        setState(() {
          dataList = res.data.details;
          pageNum = 1;
        });
      }
    });
  }

  loadMore(String userId) {
    GetUserFundDetails(userId, widget.index, pageNum + 1, pageSize).then((res) {
      if (res.code == 1000) {
        setState(() {
          pageNum = pageNum + 1;
          dataList.addAll(res.data.details);
        });
      }
    });
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 100));
    return true;
  }

  // ignore: missing_return
  Widget buildBody() {
    if (dataList == null) {
      return CircularProgressIndicator(
        backgroundColor: UIData.refresh_color,
      );
    } else if (dataList.length == 0) {
      return buildEmptyView();
    } else {
      return LoadMore(
        isFinish: dataList.length < 20,
        onLoadMore: _loadMore,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            FoundDetails fd = dataList[index];
            return buildBodyCell(fd);
          },
          itemCount: dataList.length,
        ),
      );
    }
  }

  Widget buildBodyCell(FoundDetails fd) {
    double w = MediaQuery.of(context).size.width - 100;
    Color color = fd.changeAmount.toString().indexOf("-") != -1
        ? Colors.red
        : Colors.green;

    DateTime dateTime = DateTime.parse(fd.createdAt);
    String dateStr =  formatDate(dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: w,
                child: Text(
                  fd.description,
                  maxLines: 2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  fd.changeAmount.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              dateStr,
              style: TextStyle(color: Colors.black38),
            ),
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
      loadData();
    });
  }

  Widget buildEmptyView() {
    return Container(
      height: 160,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.network_check,
            size: 50,
            color: UIData.refresh_color,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "没有更多数据",
            style: TextStyle(fontSize: 16, color: UIData.normal_font_color),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildBody(),
    );
  }
}
