import 'dart:convert';

NewsResponse newsResponseFromJson(String str) => NewsResponse.fromJson(json.decode(str));

String newsResponseToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  int code;
  String message;
  List<NewsModel> data;

  NewsResponse({
    this.code,
    this.message,
    this.data,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    code: json["code"],
    message: json["message"],
    data: List<NewsModel>.from(json["data"].map((x) => NewsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NewsModel {
  int idNews;
  int idUsers;
  String title;
  String slug;
  String images;
  String shortContent;
  String content;
  String source;
  int hits;
  int stNews;
  DateTime createdAt;
  DateTime updatedAt;

  NewsModel({
    this.idNews,
    this.idUsers,
    this.title,
    this.slug,
    this.images,
    this.shortContent,
    this.content,
    this.source,
    this.hits,
    this.stNews,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    idNews: json["id_news"],
    idUsers: json["id_users"],
    title: json["title"],
    slug: json["slug"],
    images: json["images"],
    shortContent: json["short_content"],
    content: json["content"],
    source: json["source"],
    hits: json["hits"],
    stNews: json["st_news"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_news": idNews,
    "id_users": idUsers,
    "title": title,
    "slug": slug,
    "images": images,
    "short_content": shortContent,
    "content": content,
    "source": source,
    "hits": hits,
    "st_news": stNews,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

NewsDetailResponse newsDetailResponseFromJson(String str) => NewsDetailResponse.fromJson(json.decode(str));

String newsDetailResponseToJson(NewsDetailResponse data) => json.encode(data.toJson());

class NewsDetailResponse {
  int code;
  String message;
  DetailNews data;

  NewsDetailResponse({
    this.code,
    this.message,
    this.data,
  });

  factory NewsDetailResponse.fromJson(Map<String, dynamic> json) => NewsDetailResponse(
    code: json["code"],
    message: json["message"],
    data: DetailNews.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class DetailNews {
  int idNews;
  int idUsers;
  String title;
  String slug;
  String images;
  String shortContent;
  String content;
  String source;
  int hits;
  int stNews;
  DateTime createdAt;
  DateTime updatedAt;

  DetailNews({
    this.idNews,
    this.idUsers,
    this.title,
    this.slug,
    this.images,
    this.shortContent,
    this.content,
    this.source,
    this.hits,
    this.stNews,
    this.createdAt,
    this.updatedAt,
  });

  factory DetailNews.fromJson(Map<String, dynamic> json) => DetailNews(
    idNews: json["id_news"],
    idUsers: json["id_users"],
    title: json["title"],
    slug: json["slug"],
    images: json["images"],
    shortContent: json["short_content"],
    content: json["content"],
    source: json["source"],
    hits: json["hits"],
    stNews: json["st_news"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_news": idNews,
    "id_users": idUsers,
    "title": title,
    "slug": slug,
    "images": images,
    "short_content": shortContent,
    "content": content,
    "source": source,
    "hits": hits,
    "st_news": stNews,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
