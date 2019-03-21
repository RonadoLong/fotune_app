import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserResp {
  String msg;
  int code;
  User data;

  UserResp({
    this.msg,
    this.code,
    this.data,
  });

  UserResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = User.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data.toJson();
    return data;
  }
}

class User {
  String user_id;
  String access_token;
  int expires_in;

  User({
    this.user_id,
    this.access_token,
    this.expires_in,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.user_id = json['user_id'];
    this.access_token = json['access_token'];
    this.expires_in = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['access_token'] = this.access_token;
    data['expires_in'] = this.expires_in;
    return data;
  }
}
