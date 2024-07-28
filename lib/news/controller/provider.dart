import 'package:flutter/foundation.dart';

import '../model/news.dart';
import 'api.dart';

class NewsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  changeLoad(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  NewsModel? news;
  int page = 1;
  final int pageSize = 15;
  String? category;
  String country = 'in';

  newsApiCall() async {
    changeLoad(true);
    final data = await NewsApi().newsApi(
      country,
      page,
      pageSize,
      category,
      temperature: false,
    );
    if (news == null) {
      news = data;
    } else {
      news!.articles!.addAll(data!.articles!);
    }
    changeLoad(false);
    notifyListeners();
  }

  newsFetchMore() {
    if (!isLoading) {
      page++;
      newsApiCall();
    }
  }

  changeCategory(String? data) async {
    category = data;
    page = 1;
    news = null;
    await newsApiCall();
  }

  newsCountry(String countryIs) async {
    country = countryIs;
    page = 1;
    news = null;
    await newsApiCall();
  }
}

class NewsTempProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  changeLoad(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  NewsModel? news;
  int page = 1;
  final int pageSize = 15;
  String? category;
  String? country;
  
  hotNews(String newsTitle) {
    page = 1;
    news = null;
    newsApiCall(newsTitle);
  }

  newsApiCall(String newsTitle) async {
    changeLoad(true);
    try {
      final data = await NewsApi().newsApi(
        null,
        page,
        pageSize,
        null,
        temperature: true,
        news: newsTitle,
      );
      if (news == null) {
        news = data;
      } else {
        news!.articles!.addAll(data!.articles!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    changeLoad(false);
    notifyListeners();
  }

  newsFetchMore(String newsTitle) {
    if (!isLoading) {
      page++;
      newsApiCall(newsTitle);
    }
  }
}
