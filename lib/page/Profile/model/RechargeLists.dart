class Recharge {
  String id;
  String cardNumber;
  String userName;
  String bankName;
  String qRCodeURL;
  int status;
  int type;
  String createdAt;
  String updatedAt;

  Recharge(
      {this.id,
      this.cardNumber,
      this.userName,
      this.bankName,
      this.qRCodeURL,
      this.status,
      this.type,
      this.createdAt,
      this.updatedAt});

  Recharge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardNumber = json['cardNumber'];
    userName = json['userName'];
    bankName = json['bankName'];
    qRCodeURL = json['QRCodeURL'];
    status = json['status'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardNumber'] = this.cardNumber;
    data['userName'] = this.userName;
    data['bankName'] = this.bankName;
    data['QRCodeURL'] = this.qRCodeURL;
    data['status'] = this.status;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

