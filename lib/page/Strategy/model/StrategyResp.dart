class StrategyResp {
  String msg;
  int code;
  DataBean data;

  StrategyResp({this.msg, this.code, this.data});

  StrategyResp.fromJson(Map<String, dynamic> json) {
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
  List<Strategy> myStrategy;

  DataBean({this.myStrategy});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.myStrategy = (json['myStrategy'] as List) != null
        ? (json['myStrategy'] as List).map((i) => Strategy.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myStrategy'] = this.myStrategy != null
        ? this.myStrategy.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class Strategy {
  String stockCode;
  String stockName;
  String buyPrice;
  String localPrice;
  var amount;
  var profit;
  var count;
  DetailBean Detail;
  bool isShow = true;

  Strategy(
      {this.stockCode,
      this.stockName,
      this.buyPrice,
      this.localPrice,
      this.amount,
      this.profit,
      this.count,
      this.Detail});

  Strategy.fromJson(Map<String, dynamic> json) {
    this.stockCode = json['stockCode'];
    this.stockName = json['stockName'];
    this.buyPrice = json['buyPrice'];
    this.localPrice = json['localPrice'];
    this.amount = json['amount'];
    this.profit = json['profit'];
    this.count = json['count'];
    this.Detail =
        json['Detail'] != null ? DetailBean.fromJson(json['Detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCode'] = this.stockCode;
    data['stockName'] = this.stockName;
    data['buyPrice'] = this.buyPrice;
    data['localPrice'] = this.localPrice;
    data['amount'] = this.amount;
    data['profit'] = this.profit;
    data['count'] = this.count;
    if (this.Detail != null) {
      data['Detail'] = this.Detail.toJson();
    }
    return data;
  }
}

class DetailBean {
  String buyTime;
  String orderNo;
  var creditAmount;
  var stopLoss;
  String floatProfit;

  DetailBean(
      {this.buyTime,
      this.orderNo,
      this.creditAmount,
      this.stopLoss,
      this.floatProfit});

  DetailBean.fromJson(Map<String, dynamic> json) {
    this.buyTime = json['buyTime'];
    this.orderNo = json['orderNo'];
    this.creditAmount = json['creditAmount'];
    this.stopLoss = json['stopLoss'];
    this.floatProfit = json['floatProfit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyTime'] = this.buyTime;
    data['orderNo'] = this.orderNo;
    data['creditAmount'] = this.creditAmount;
    data['stopLoss'] = this.stopLoss;
    data['floatProfit'] = this.floatProfit;
    return data;
  }
}
