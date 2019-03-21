import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MarketResp extends Object {
  @JsonKey(name: "msg")
  String msg;
  @JsonKey(name: "code")
  int code;
  @JsonKey(name: "data")
  List<Market> data;

  MarketResp({
    this.msg,
    this.code,
    this.data,
  });

  MarketResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => Market.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

@JsonSerializable()
class Market extends Object {
  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "change")
  String change;

  @JsonKey(name: "close")
  String close;

  Market({
    this.name,
    this.change,
    this.close,
  });

  Market.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.change = json['change'];
    this.close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['change'] = this.change;
    data['close'] = this.close;
    return data;
  }
}
