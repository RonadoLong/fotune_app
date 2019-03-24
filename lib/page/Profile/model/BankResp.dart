class BankResp {
  Null paginator;
  List<Banks> banks;

  BankResp({this.paginator, this.banks});

  BankResp.fromJson(Map<String, dynamic> json) {
    paginator = json['paginator'];
    if (json['banks'] != null) {
      banks = new List<Banks>();
      json['banks'].forEach((v) {
        banks.add(new Banks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paginator'] = this.paginator;
    if (this.banks != null) {
      data['banks'] = this.banks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banks {
  String id;
  String userID;
  String accountHolder;
  String bankName;
  String province;
  String city;
  String branchName;
  String cardNumber;
  int status;
  String createdAt;
  String updatedAt;

  Banks(
      {this.id,
      this.userID,
      this.accountHolder,
      this.bankName,
      this.province,
      this.city,
      this.branchName,
      this.cardNumber,
      this.status,
      this.createdAt,
      this.updatedAt});

  Banks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    accountHolder = json['accountHolder'];
    bankName = json['bankName'];
    province = json['province'];
    city = json['city'];
    branchName = json['branchName'];
    cardNumber = json['cardNumber'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userID'] = this.userID;
    data['accountHolder'] = this.accountHolder;
    data['bankName'] = this.bankName;
    data['province'] = this.province;
    data['city'] = this.city;
    data['branchName'] = this.branchName;
    data['cardNumber'] = this.cardNumber;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
