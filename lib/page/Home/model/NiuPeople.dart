class NiuPeopleResp {
  String msg;
  int code;
  List<NiuPeople> data;

  NiuPeopleResp({this.msg, this.code, this.data});

  NiuPeopleResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => NiuPeople.fromJson(i)).toList()
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

class NiuPeople {
  String name;
  String winRate;
  String returnRate;
  int id;
  int strategyCount;
  int status;

  NiuPeople(
      {this.name,
      this.winRate,
      this.returnRate,
      this.id,
      this.strategyCount,
      this.status});

  NiuPeople.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.winRate = json['winRate'];
    this.returnRate = json['returnRate'];
    this.id = json['id'];
    this.strategyCount = json['strategyCount'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['winRate'] = this.winRate;
    data['returnRate'] = this.returnRate;
    data['id'] = this.id;
    data['strategyCount'] = this.strategyCount;
    data['status'] = this.status;
    return data;
  }
}
