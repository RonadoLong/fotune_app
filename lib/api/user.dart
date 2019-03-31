import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/model/Response.dart';
import 'package:fotune_app/model/User.dart';
import 'package:flustars/flustars.dart';
import 'package:fotune_app/model/UserInfo.dart';

// ignore: non_constant_identifier_names
Future<Response> RegisterUser(params) async {
  var url = "/user/register";
  var response = await Http().post(url, data: params);
  print(response['code']);
  var res = Response.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<Response> GetCode(phone) async {
  var url = "/info/sendMessage/$phone";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<UserResp> Login(params) async {
  var url = "/user/login";
  var response = await Http().post(url, data: params);
  var res = UserResp.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<UserInfoResp> GetUserInfo(String userID) async {
  var url = "/user/" + userID;
  var response = await Http().get(url);
  var res = UserInfoResp.fromJson(response);
  print("=================== user $res");
  return res;
}

// ignore: non_constant_identifier_names
User GetLocalUser() {
  bool have = SpUtil.haveKey("userInfo");
  if (have == false) {
    print("用户数据不存在 ============== ");
    return null;
  }
  var json = SpUtil.getObject("userInfo");
  return User.fromJson(json);
}

// ignore: non_constant_identifier_names
Future<Response> BindRealName(params) async {
  var url = "/user/realName";
  var response = await Http().put(url, data: params);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> UpdatePwd(params) async {
  var url = "/user/modifyPwd";
  var response = await Http().put(url, data: params);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> GetBankList(uid) async {
  var url = "/bank/list/$uid";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> AddBank(query) async {
  var url = "/bank/add";
  var response = await Http().post(url, data: query);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> GetRechargeLists() async {
  var url = "/recharge";
  var response = await Http().get(url);
  var res = Response.fromJson(response);
  return res;
}

Future<Response> PostTiXian(params) async {
  var url = "/user/withdraw";
  var response = await Http().post(url, data: params);
  var res = Response.fromJson(response);
  return res;
}
