class CarouselResp {
  int code;
  String msg;
  List<Carousel> data;

  CarouselResp({this.code, this.msg, this.data});

  CarouselResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Carousel>();
      json['data'].forEach((v) {
        data.add(new Carousel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carousel {
  int id;
  String title;
  String url;
  int sort;

  Carousel({this.id, this.title, this.url, this.sort});

  Carousel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['sort'] = this.sort;
    return data;
  }
}
