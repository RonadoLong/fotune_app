import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fotune_app/api/home.dart';
import 'package:fotune_app/componets/news/ListImageRight.dart';
import 'package:fotune_app/page/Home/NewsDetailsPage.dart';
import 'package:fotune_app/page/Home/model/News.dart';
import 'package:fotune_app/page/common/CommonWidget.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/ToastUtils.dart';
import 'package:fotune_app/utils/UIData.dart';

class HomeNewsPage extends StatefulWidget {
  @override
  HomeNewsPageState createState() => HomeNewsPageState();
}

class HomeNewsPageState extends State<HomeNewsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @protected
  List<News> newsLists = [];

  @protected
  final ScrollController _scrollController = new ScrollController();

  @protected
  int pageNum = 1;

  @protected
  int pageSize = 10;

  @override
  void initState() {
    super.initState();

    loadData(START_REQUEST);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadData(LOADMORE_REQIEST);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    if (newsLists.length == 0 || newsLists.isEmpty) {
      return new Center(
        child: CircularProgressIndicator(
          backgroundColor: UIData.refresh_color,
        ),
      );
    } else {
      return new RefreshIndicator(
          onRefresh: (() => _handleRefresh()),
          color: UIData.refresh_color, //刷新控件的颜色
          child: ListView.separated(
            itemCount: _getListCount(),
            controller: _scrollController, //用于监听是否滑到最底部
            itemBuilder: (context, index) {
              if (index < newsLists.length) {
                News data = newsLists[index];
                return GestureDetector(
                  onTap: () {
                    onItemClick(index);
                  },
                  child: ListImageRight(context, data),
                );
              } else {
                return BuildLoadMoreView(); //展示加载loading框
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

  _getListCount() {
    return (newsLists.length > 0) ? newsLists.length + 1 : newsLists.length;
  }

  // ///上拉加载更多
  // Widget _buildProgressIndicator() {
  //   Widget bottomWidget =
  //       new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //     new SpinKitThreeBounce(color: Color(0xFF24292E)),
  //     new Container(
  //       width: 5.0,
  //     ),
  //   ]);
  //   return new Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: new Center(
  //       child: bottomWidget,
  //     ),
  //   );
  // }

  void onItemClick(int i) {
    News data = newsLists[i];
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new NewsDetailsPage(data.articleTitle, data.articleContent)));
  }

  /// 获取数据
  void loadData(int requestType) async {
    var currenPage = requestType == REFRESH_REQIEST ? 1 :pageNum + 1;
 
    GetNewsList(currenPage, pageSize).then((res) {
      if (res.code == 1000) {
        var newsData = NewsData.fromJson(res.data);
        if (requestType != LOADMORE_REQIEST) {
          setState(() {
            newsLists = newsData.news;
          });
        } else {
          setState(() {
            newsLists.addAll(newsData.news);
          });
        }

      setState(() {
        pageNum = currenPage;
      });
       
      } else if (res.code == 1004) {
        ShowToast("没有更多数据了");
      }
    }).catchError((err) {
      ShowToast("网络出错");
    });
  }
}
