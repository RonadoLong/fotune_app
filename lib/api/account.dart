import 'package:fotune_app/api/HttpUtils.dart';
import 'package:fotune_app/page/Profile/model/FoundDetailResp.dart';

// ignore: non_constant_identifier_names
Future<FoundDetailResp> GetUserFundDetails(
    String uid, int type, int pageNum, int pageSize) async {
  var url = "/account/details/$uid/$type/$pageNum/$pageSize";
  var response = await Http().get(url);
  var res = FoundDetailResp.fromJson(response);
  return res;
}
