import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fotune_app/componets/news/ListImageRight.dart';
import 'package:fotune_app/model/ListEnity.dart';
import 'package:fotune_app/model/news_enity.dart';
import 'package:fotune_app/page/Home/NewsDetailsPage.dart';
import 'package:fotune_app/utils/Constants.dart';
import 'package:fotune_app/utils/StringUtil.dart';
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

  List<ListEnity> newsList = [];

  int lastOneId;
  int lastOneIdStart = 0;
  int lastone_id_end = 0;
  bool has_next_page = true;

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    getInfoList(START_REQUEST);

    _scrollController.addListener(() {
      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("========================================= load more");
        getInfoList(LOADMORE_REQIEST);
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
      getInfoList(REFRESH_REQIEST);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    if (newsList.length == 0 || newsList.isEmpty) {
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
              if (index < newsList.length) {
                Data data = newsList[index].data;
                return GestureDetector(
                  onTap: () {
                    onItemClick(index);
                  },
                  child: ListImageRight(context, data),
                );
              } else {
                return _buildProgressIndicator(); //展示加载loading框
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
    ///如果有数据,最上面是轮播图最下面是加载loading动画，需要对列表数据总数+2
    return (newsList.length > 0) ? newsList.length + 1 : newsList.length;
  }

  ///上拉加载更多
  Widget _buildProgressIndicator() {
    ///是否需要显示上拉加载更多的loading
    Widget bottomWidget =
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      new SpinKitThreeBounce(color: Color(0xFF24292E)),
      new Container(
        width: 5.0,
      ),
    ]);
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }

//  Future<Null> pullToRefresh() async {
//    getInfoList(REFRESH_REQIEST);
//    return null;
//  }
//
//  Future<Null> onFooterRefresh() async {
//    getInfoList(LOADMORE_REQIEST);
//    return null;
//  }

  void onItemClick(int i) {
    Data data = newsList[i].data as Data;
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new NewsDetailsPage(data.articleTitle, data.articleContent)));
  }

  /// 获取数据
  void getInfoList(int request_type) async {
    String query;
    if (request_type != LOADMORE_REQIEST) {
      query =
          "source(limit: 10,sort:\"desc\"),{data{}, page_info{has_next_page, end_cursor}}";
    } else {
      if (lastOneId > 1) {
        lastOneIdStart = lastOneId - 21;
        lastone_id_end = lastOneId - 1;
        if (lastOneIdStart < 1) {
          lastOneIdStart = 1;
        }
        query =
            "source(limit: 10,__id:{gte:${lastOneIdStart},lte:${lastone_id_end}},sort:\"desc\"),{data{}, page_info{has_next_page, end_cursor}}";
      } else {
        query = "";
      }
    }
    if (query != null && query.isNotEmpty) {
      String url = GetFinanceNewsUrl(query);
      Dio dio = new Dio();
      Response response = await dio.get(url);
      var jsonString = response.data;
      DealDatas(jsonString, request_type);
    } else {
      ShowToast("已经没有更多了");
    }
  }

  /// 处理请求到的数据
  void DealDatas(jsonString, int requestType) {
    try {
      var news = new news_enity.fromJson(jsonString);
      var code = news.code;
      // print(news);
      if (code == 0) {
        Result result = news.result;
        lastOneId = result.pageInfo.endCursor;
        has_next_page = result.pageInfo.hasNextPage;
        setState(() {
          if (requestType != LOADMORE_REQIEST) {
            // 不是加载更多，则直接为变量赋值
            for (Data data in result.data) {
              ListEnity listEnity = new ListEnity("main", data);
              newsList.add(listEnity);
            }
          } else {
            // 是加载更多，则需要将取到的news数据追加到原来的数据后面
            List<ListEnity> list1 = new List<ListEnity>();
            list1.addAll(newsList);
            for (Data data in result.data) {
              ListEnity listEnity = new ListEnity("main", data);
              list1.add(listEnity);
            }
            newsList = list1;
          }
          // 判断是否获取了所有的数据，如果是，则需要显示底部的"我也是有底线的"布局
          if (has_next_page == false &&
              "endline" != newsList[newsList.length].type) {
            ListEnity listEnity = new ListEnity("endline", null);
            newsList.add(listEnity);
          }
          if (requestType == REFRESH_REQIEST) {
            ShowToast("刷新成功");
          }
        });
      } else {
        ShowToast(news.error_info);
      }
    } catch (e) {
      print("异常==》" + e.toString());
    }
  }
}
