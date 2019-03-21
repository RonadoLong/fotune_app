import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserInfoResp {
  String msg;
  int code;
  UserInfo data;

  UserInfoResp({
    this.msg,
    this.code,
    this.data,
  });

  UserInfoResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = UserInfo.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data.toJson();
    return data;
  }
}

class UserInfo {
  String id;
  String userName;
  String email;
  String phone;
  String realName;
  String institutionalCode;
  String idCard;
  String createdAt;
  String updatedAt;
  int status;
  double amount;

  UserInfo({
    this.id,
    this.userName,
    this.email,
    this.phone,
    this.realName,
    this.institutionalCode,
    this.idCard,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.amount,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userName = json['userName'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.realName = json['realName'];
    this.institutionalCode = json['institutionalCode'];
    this.idCard = json['idCard'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
    this.status = json['status'];
    this.amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['realName'] = this.realName;
    data['institutionalCode'] = this.institutionalCode;
    data['idCard'] = this.idCard;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    data['amount'] = this.amount;
    return data;
  }
}
