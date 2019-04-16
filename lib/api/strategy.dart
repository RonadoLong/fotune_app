import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/model/Response.dart';
import 'package:fotune_app/page/Strategy/model/FinishStrategyResp.dart';
import 'package:fotune_app/page/Strategy/model/StrategyResp.dart';
import 'package:fotune_app/page/stock/model/SearchResp.dart';

Future<Response> AddStrategy(params) async {
  var url = "/strategy/add";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> AddCredit(params) async {
  var url = "/strategy/addCredit";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}


Future<Response> QueryShellStrategy(params) async {
  var url = "/strategy/close";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<StrategyResp> GetStrategyList(uid, pageNum, pageSize) async {
  var url = "/strategy/MyList/$uid/$pageNum/$pageSize";
  var response = await Http().get(url);
  print(response);
  var res = StrategyResp.fromJson(response);
  return res;
}

Future<FinishStrategyResp> GetCloseList(uid, pageNum, pageSize) async {
  var url = "/strategy/closeList/$uid/$pageNum/$pageSize";
  var response = await Http().get(url);
  var res = FinishStrategyResp.fromJson(response);
  return res;
}

Future<SearchResp> GetStockList(keyword) async {
  var url = "/stock/query/$keyword";
  var response = await Http().get(url);
  var res = SearchResp.fromJson(response);
  return res;
}

Future<Response> AddStock(params) async {
  var url = "/stock/add";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> GetOptionalList(uid) async {
  var url = "/stock/optionalList/$uid";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> DelOptional(params) async {
  var url = "/stock/deleteOptional";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}
