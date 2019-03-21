class SearchResp {
  String msg;
  int code;
  List<SearchStock> data;

  SearchResp({this.msg, this.code, this.data});

  SearchResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => SearchStock.fromJson(i)).toList()
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

class SearchStock {
  String id;
  String code;
  String name;
  String jianPin;
  String type;
  String market;
  String createdAt;
  String updatedAt;
  int status;

  SearchStock(
      {this.id,
      this.code,
      this.name,
      this.jianPin,
      this.type,
      this.market,
      this.createdAt,
      this.updatedAt,
      this.status});

  SearchStock.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.code = json['code'];
    this.name = json['name'];
    this.jianPin = json['jianPin'];
    this.type = json['type'];
    this.market = json['market'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['jianPin'] = this.jianPin;
    data['type'] = this.type;
    data['market'] = this.market;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}
