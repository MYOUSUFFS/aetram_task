import 'package:flutter/foundation.dart';

import '../../setting/local.dart';
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
  String? _category;
  String? get category => _category;

  set category(String? value) {
    SharedPreferencesService.setCategory(value);
    _category = category;
    notifyListeners();
  }

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
    _category = data;
    page = 1;
    news = null;
    await newsApiCall();
  }

  newsCountry(String countryIs) async {
    _category = countryIs;
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

  NewsModel? _news;
  NewsModel? get news => _news;
  int page = 1;
  final int pageSize = 15;
  String? category;
  String? country;

  hotNews(String newsTitle) async {
    page = 1;
    _news = null;
    await newsApiCall(newsTitle);
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
      if (_news == null) {
        _news = data;
      } else {
        _news!.articles!.addAll(data!.articles!);
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
