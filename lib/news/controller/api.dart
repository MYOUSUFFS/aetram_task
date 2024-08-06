// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:sentiment_dart/sentiment_dart.dart';

import '../model/news.dart';
import '../view/utils/static.dart';

class NewsApi {
  String apiUrl = "https://newsapi.org/";
  String apiVersion = "v2/";

  Future<NewsModel?> newsApi(
      String? country, int page, int pageSize, String? category,
      {required bool temperature, String? news}) async {
    try {
      String url = '';
      if (!temperature) {
        url = category != null
            ? "$apiUrl${apiVersion}top-headlines?country=$country&category=$category&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}"
            : "$apiUrl${apiVersion}top-headlines?country=$country&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}";
      } else {
        url =
            // "$apiUrl${apiVersion}top-headlines?country=in&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}";
            "$apiUrl${apiVersion}everything?q=india&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}";
      }
      final response = await http.get(Uri.parse(url));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final news = newsModelFromJson(response.body);
        if (temperature) {
          if (news.articles != null) {
            for (var x in news.articles!) {
              if (x.title != null) {
                final sentiment = Sentiment.analysis(x.title!);
                final jsonIs = {
                  "score": sentiment.score,
                  "comparative": sentiment.comparative,
                  "words": {
                    "all": sentiment.words.all,
                    "good": sentiment.words.good,
                    "bad": sentiment.words.bad,
                  }
                };
                x.sentimentNews = SentimentNews.fromJson(jsonIs);
              }
            }
          }
        }
        // print(jsonEncode(news.toJson()));
        return news;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
