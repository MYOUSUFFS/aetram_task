// ignore_for_file: avoid_print

import 'package:aetram_task/news/view/static.dart';
import 'package:http/http.dart' as http;

import '../model/news.dart';

class NewsApi {
  String apiUrl = "https://newsapi.org/";
  String apiVersion = "v2/";

  Future<NewsModel?> topHeadingApi() async {
    try {
      String url =
          "$apiUrl${apiVersion}top-headlines?country=in&apiKey=${StaticData.apiKey}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return newsModelFromJson(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<NewsModel?> fetchUsers(
      String country, int page, int pageSize, String? category) async {
    try {
      String url = category != null
          ? "$apiUrl${apiVersion}top-headlines?country=$country&category=$category&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}"
          : "$apiUrl${apiVersion}top-headlines?country=$country&page=$page&pageSize=$pageSize&apiKey=${StaticData.apiKey}";
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return newsModelFromJson(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
