import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Response extends Object {
  @JsonKey(name: "msg")
  String msg;
  @JsonKey(name: "code")
  int code;
  @JsonKey(name: "data")
  dynamic data;

  Response({
    this.msg,
    this.code,
    this.data,
  });

  Response.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = json['data'];
  }
}
