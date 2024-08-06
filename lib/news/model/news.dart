// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  String? status;
  int? totalResults;
  List<Article>? articles;

  NewsModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles != null
            ? List<dynamic>.from(articles!.map((x) => x.toJson()))
            : null,
      };

  NewsModel copyWith({
    String? status,
    int? totalResults,
    List<Article>? articles,
  }) {
    return NewsModel(
      status: status,
      totalResults: totalResults,
      articles: articles,
    );
  }
}

class Article {
  Source? source;
  String? author;
  String? title;
  dynamic description;
  String? url;
  dynamic urlToImage;
  DateTime? publishedAt;
  dynamic content;
  SentimentNews? sentimentNews;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.sentimentNews,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json["source"] == null ? null : Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
        sentimentNews: json["sentimentNews"] != null
            ? SentimentNews.fromJson(json["sentimentNews"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content,
        "sentimentNews": sentimentNews?.toJson(),
      };
}

class Source {
  String? id;
  String? name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

List<SentimentNews> sentimentNewsFromJson(String str) =>
    List<SentimentNews>.from(
        json.decode(str).map((x) => SentimentNews.fromJson(x)));

String sentimentNewsToJson(List<SentimentNews> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SentimentNews {
  int? score;
  double? comparative;
  Words? words;

  SentimentNews({
    this.score,
    this.comparative,
    this.words,
  });

  factory SentimentNews.fromJson(Map<String, dynamic> json) => SentimentNews(
        score: json["score"],
        comparative: json["comparative"]?.toDouble(),
        words: json["words"] == null ? null : Words.fromJson(json["words"]),
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "comparative": comparative,
        "words": words?.toJson(),
      };
}

class Words {
  List<String>? all;
  Map<String, dynamic>? good;
  Map<String, dynamic>? bad;

  Words({
    this.all,
    this.good,
    this.bad,
  });

  factory Words.fromJson(Map<String, dynamic> json) => Words(
        all: List<String>.from(json["all"].map((x) => x)),
        good: json["good"],
        bad: json["bad"],
      );

  Map<String, dynamic> toJson() => {
        "all": all != null ? List<dynamic>.from(all!.map((x) => x)) : null,
        "good": good,
        "bad": bad,
      };
}
