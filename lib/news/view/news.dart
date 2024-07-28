import 'package:aetram_task/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/news.dart';
import '../controller/api.dart';
import 'category.dart';
import 'widget/selected_country.dart';

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
      page = 1;
      news = null;
      await _fetchUsers();
    }
    setState(() {});
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
    return LayoutBuilder(
      builder: (context, sizeIs) {
        return Scaffold(
          drawer: sizeIs.maxWidth < ScreenSize.width
              ? const AppDrawer(pagename: 'News')
              : null,
          appBar: AppBar(
            title: const Text('News Feeds'),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await countryNameFind();
                },
                icon: const Icon(Icons.edit_location_alt),
                label: Text(
                  countryName,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
            centerTitle: true,
          ),
          body: Stack(
            children: [
              if (news != null) ...[
                Row(
                  children: [
                    if (sizeIs.maxWidth > ScreenSize.width)
                      const AppDrawer(pagename: 'News'),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 45, child: CategoryWidget()),
                          const Divider(),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[100],
                              ),
                              shrinkWrap: true,
                              controller: controller,
                              physics: const BouncingScrollPhysics(),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (article.urlToImage
                                                    is String) ...[
                                                  Image.network(
                                                      article.urlToImage,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const SizedBox()),
                                                ],
                                                Text(
                                                  article.title ?? '',
                                                  style: const TextStyle(
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
                                              debugPrint(e.toString());
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('No URL found')));
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('article error'));
                                }
                              },
                            ),
                          ),
                        ],
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
      },
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
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: SafeArea(
        child: loading == 100
            ? WebViewWidget(controller: controller)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
