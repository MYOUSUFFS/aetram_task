// ignore_for_file: prefer_const_constructors, avoid_print

// ignore: avoid_web_libraries_in_flutter

import 'package:aetram_task/news/view/static.dart';
import 'package:aetram_task/news/view/widget/selected_country.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:aetram_task/news/controller/api.dart';

import '../model/news.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({super.key});

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  NewsModel? news;
  String country = 'in';
  String countryName = 'India';
  final ScrollController controller = ScrollController();
  bool isLoading = false;
  int page = 1;
  final int pageSize = 15;
  String? category;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _fetchMoreUsers();
      }
    });
  }

  countryNameFind() async {
    final data = await SelectedCountry(context: context).showListOfCountry();
    if (data != null) {
      country = data['country_code'];
      countryName = data['country_name'];
      category = null;
      page = 1;
      setState(() {});
      await _fetchUsers();
      setState(() {});
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    final data = await NewsApi().fetchUsers(country, page, pageSize, category);
    if (news == null) {
      news = data;
    } else {
      news!.articles!.addAll(data!.articles!);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _fetchMoreUsers() {
    if (!isLoading) {
      page++;
      _fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feeds'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await countryNameFind();
              },
              icon: Icon(Icons.edit_location_alt),
              label: Text(
                countryName,
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ))
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (news != null) ...[
            Column(
              children: [
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: StaticData.category.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        news = null;
                        page = 1;
                        if (index != 0) {
                          category = StaticData.category[index];
                        } else {
                          category = null;
                        }
                        _fetchUsers();
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: StaticData.category[index] == category
                              ? Colors.green[800]
                              : null,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          StaticData.category[index].toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[100],
                    ),
                    shrinkWrap: true,
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    itemCount: news!.articles?.length ?? 0,
                    itemBuilder: (context, index) {
                      if (news!.articles != null) {
                        final article = news!.articles![index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: article.title != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (article.urlToImage is String) ...[
                                        Image.network(article.urlToImage,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    SizedBox()),
                                      ],
                                      Text(
                                        article.title ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                            subtitle: article.description != null
                                ? Text(
                                    article.description ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                    ),
                                  )
                                : null,
                            onTap: () async {
                              if (article.url != null) {
                                if (kIsWeb) {
                                  try {
                                    if (!await canLaunchUrl(
                                        Uri.parse(article.url!))) {
                                      throw Exception(
                                          'Could not launch ${article.url}');
                                    }
                                    await launchUrl(
                                      Uri.parse(article.url!),
                                      webOnlyWindowName: '_self',
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return WebViewNews(
                                          url: article.url!,
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No URL found')));
                              }
                            },
                          ),
                        );
                      } else {
                        return Center(child: Text('article error'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ] else ...[
            const Center(child: CircularProgressIndicator())
          ]
        ],
      ),
    );
  }
}

class WebViewNews extends StatefulWidget {
  const WebViewNews({super.key, required this.url});
  final String url;

  @override
  State<WebViewNews> createState() => _WebViewNewsState();
}

class _WebViewNewsState extends State<WebViewNews> {
  late WebViewController controller;
  int loading = 0;

  @override
  void initState() {
    webView();
    super.initState();
  }

  webView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            loading = progress;
            if (mounted) setState(() {});
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading == 100
            ? WebViewWidget(controller: controller)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
