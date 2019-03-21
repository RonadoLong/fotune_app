import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/model/Market.dart';
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

Future<NiuPeopleResp> GetNiuPeoples() async {
  var url = "/home/niu";
  var response = await Http().get(url);
  var niuPeople = NiuPeopleResp.fromJson(response);
  return niuPeople;
}
