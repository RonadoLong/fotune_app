class FinishStrategyResp {
  String msg;
  int code;
  DataBean data;

  FinishStrategyResp({this.msg, this.code, this.data});

  FinishStrategyResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = json['data'] != null ? DataBean.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataBean {
  List<CloseStrategys> strategys;

  DataBean({ this.strategys});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.strategys = (json['strategys'] as List) != null
        ? (json['strategys'] as List)
            .map((i) => CloseStrategys.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strategys'] = this.strategys != null
        ? this.strategys.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class CloseStrategys {
  String id;
  String sellTime;
  String stockCode;
  String stockName;
  var profit;
  DetailBean detail;
  bool isShow = true;

  CloseStrategys(
      {this.id,
      this.sellTime,
      this.stockCode,
      this.stockName,
      this.profit,
      this.detail});

  CloseStrategys.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.sellTime = json['sellTime'];
    this.stockCode = json['stockCode'];
    this.stockName = json['stockName'];
    this.profit = json['profit'];
    this.detail =
        json['detail'] != null ? DetailBean.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellTime'] = this.sellTime;
    data['stockCode'] = this.stockCode;
    data['stockName'] = this.stockName;
    data['profit'] = this.profit;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    return data;
  }
}

class DetailBean {
  String ord;
  String buyTime;
  String sellTime;
  String tranProfit;
  String handleFee;
  var tranAmount;
  var buyPrice;
  var sellPrice;
  var buildingFee;
  var closingFee;
  String buyType;
  var deferredFee;

  DetailBean(
      {this.ord,
      this.buyTime,
      this.sellTime,
      this.tranProfit,
      this.handleFee,
      this.tranAmount,
      this.buyPrice,
      this.sellPrice,
      this.buildingFee,
      this.closingFee,
      this.buyType,
      this.deferredFee});

  DetailBean.fromJson(Map<String, dynamic> json) {
    this.ord = json['ord'];
    this.buyTime = json['buyTime'];
    this.sellTime = json['sellTime'];
    this.tranProfit = json['tranProfit'];
    this.handleFee = json['handleFee'];
    this.tranAmount = json['tranAmount'];
    this.buyPrice = json['buyPrice'];
    this.sellPrice = json['sellPrice'];
    this.buildingFee = json['buildingFee'];
    this.closingFee = json['closingFee'];
    this.buyType = json['buyType'];
    this.deferredFee = json['deferredFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ord'] = this.ord;
    data['buyTime'] = this.buyTime;
    data['sellTime'] = this.sellTime;
    data['tranProfit'] = this.tranProfit;
    data['handleFee'] = this.handleFee;
    data['tranAmount'] = this.tranAmount;
    data['buyPrice'] = this.buyPrice;
    data['sellPrice'] = this.sellPrice;
    data['buildingFee'] = this.buildingFee;
    data['closingFee'] = this.closingFee;
    data['buyType'] = this.buyType;
    data['deferredFee'] = this.deferredFee;
    return data;
  }
}
