import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/model/Response.dart';

// ignore: non_constant_identifier_names
Future<Response> GetSettings() async {
  var url = "/setting/get";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> GetSettingsBanks() async {
  var url = "/setting/bank/list";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}
