class FoundDetailResp {
  String msg;
  int code;
  DataBean data;

  FoundDetailResp({this.msg, this.code, this.data});

  FoundDetailResp.fromJson(Map<String, dynamic> json) {
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
  PaginatorBean paginator;
  List<FoundDetails> details;

  DataBean({this.paginator, this.details});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.paginator = json['paginator'] != null
        ? PaginatorBean.fromJson(json['paginator'])
        : null;
    this.details = (json['details'] as List) != null
        ? (json['details'] as List)
            .map((i) => FoundDetails.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paginator != null) {
      data['paginator'] = this.paginator.toJson();
    }
    data['details'] = this.details != null
        ? this.details.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class PaginatorBean {
  int PageSize;
  int CurrentPage;
  int TotalCount;
  int PageCount;

  PaginatorBean(
      {this.PageSize, this.CurrentPage, this.TotalCount, this.PageCount});

  PaginatorBean.fromJson(Map<String, dynamic> json) {
    this.PageSize = json['PageSize'];
    this.CurrentPage = json['CurrentPage'];
    this.TotalCount = json['TotalCount'];
    this.PageCount = json['PageCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageSize'] = this.PageSize;
    data['CurrentPage'] = this.CurrentPage;
    data['TotalCount'] = this.TotalCount;
    data['PageCount'] = this.PageCount;
    return data;
  }
}

class FoundDetails {
  String id;
  String accountID;
  String strategyID;
  String description;
  String createdAt;
  String updatedAt;
  var changeAmount;
  var afterChange;
  var deferredFee;
  var creditAmount;
  var handlingFee;
  var closingFee;
  var status;
  var detailType;
  var profit;

  FoundDetails(
      {this.id,
      this.accountID,
      this.strategyID,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.changeAmount,
      this.afterChange,
      this.deferredFee,
      this.creditAmount,
      this.handlingFee,
      this.closingFee,
      this.status,
      this.detailType,
      this.profit});

  FoundDetails.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.accountID = json['accountID'];
    this.strategyID = json['strategyID'];
    this.description = json['description'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
    this.changeAmount = json['changeAmount'];
    this.afterChange = json['afterChange'];
    this.deferredFee = json['deferredFee'];
    this.creditAmount = json['creditAmount'];
    this.handlingFee = json['handlingFee'];
    this.closingFee = json['closingFee'];
    this.status = json['status'];
    this.detailType = json['detailType'];
    this.profit = json['profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountID'] = this.accountID;
    data['strategyID'] = this.strategyID;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['changeAmount'] = this.changeAmount;
    data['afterChange'] = this.afterChange;
    data['deferredFee'] = this.deferredFee;
    data['creditAmount'] = this.creditAmount;
    data['handlingFee'] = this.handlingFee;
    data['closingFee'] = this.closingFee;
    data['status'] = this.status;
    data['detailType'] = this.detailType;
    data['profit'] = this.profit;
    return data;
  }
}
