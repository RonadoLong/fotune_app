import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/model/Market.dart';
import 'package:fotune_app/model/Response.dart';
import 'package:fotune_app/page/Home/model/NiuPeople.dart';

GetInfoList(url) async {
  var response = await Http().get(url);
  return response;
}

Future<MarketResp> GetMarkets() async {
  var url = "/home/market";
  var response = await Http().get(url);
  var market = MarketResp.fromJson(response);
  return market;
}

Future<Response> GetNiuPeoples() async {
  var url = "/home/niu";
  var res = await Http().get(url);
  var reponse = Response.fromJson(res);
  return reponse;
}

Future<Response> GetNewsList(int pageNum, int pageSize) async {
  var url = "/home/news/$pageNum/$pageSize";
  var res = await Http().get(url);
  var reponse = Response.fromJson(res);
  return reponse;
}

