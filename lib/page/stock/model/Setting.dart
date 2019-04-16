class Setting {
  var id;
  String multiple;
  String credit;

  Setting({this.id, this.multiple, this.credit});

  Setting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    multiple = json['multiple'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['multiple'] = this.multiple;
    data['credit'] = this.credit;
    return data;
  }
}
