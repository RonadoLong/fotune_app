import 'package:json_annotation/json_annotation.dart';


class NewsData {
  var paginator;
  List<News> news;

  NewsData({this.paginator, this.news});

  NewsData.fromJson(Map<String, dynamic> json) {
    this.paginator = json['paginator'];
    this.news = (json['news'] as List) != null
        ? (json['news'] as List).map((i) => News.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paginator'] = this.paginator;
    data['news'] = this.news != null
        ? this.news.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

@JsonSerializable()
class News extends Object {
  @JsonKey(name: 'article_title')
  String articleTitle;

  @JsonKey(name: 'article_brief')
  String articleBrief;

  @JsonKey(name: 'article_content')
  String articleContent;

  @JsonKey(name: 'article_author')
  String articleAuthor;

  @JsonKey(name: 'article_avatar')
  String articleAvatar;

  @JsonKey(name: 'article_publish_time')
  String articlePublishTime;

  @JsonKey(name: 'article_thumbnail')
  String articleThumbnail;

  @JsonKey(name: 'article_categories')
  List<String> articleCategories;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: '__id')
  int id;

  @JsonKey(name: '__time')
  int time;

  @JsonKey(name: '__url')
  String url;

  News(
    this.articleTitle,
    this.articleBrief,
    this.articleContent,
    this.articleAuthor,
    this.articleAvatar,
    this.articlePublishTime,
    this.articleThumbnail,
    this.articleCategories,
    this.comment,
    this.id,
    this.time,
    this.url,
  );

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        json['article_title'] as String,
        json['article_brief'] as String,
        json['article_content'] as String,
        json['article_author'] as String,
        json['article_avatar'] as String,
        json['article_publish_time'] as String,
        json['article_thumbnail'] as String,
        (json['article_categories'] as List)?.map((e) => e as String)?.toList(),
        json['comment'] as String,
        json['__id'] as int,
        json['__time'] as int,
        json['__url'] as String);
  }

  Map<String, dynamic> toJson() => _$DataToJson(this);

  Map<String, dynamic> _$DataToJson(News instance) => <String, dynamic>{
        'article_title': instance.articleTitle,
        'article_brief': instance.articleBrief,
        'article_content': instance.articleContent,
        'article_author': instance.articleAuthor,
        'article_avatar': instance.articleAvatar,
        'article_publish_time': instance.articlePublishTime,
        'article_thumbnail': instance.articleThumbnail,
        'article_categories': instance.articleCategories,
        'comment': instance.comment,
        '__id': instance.id,
        '__time': instance.time,
        '__url': instance.url
      };
}
