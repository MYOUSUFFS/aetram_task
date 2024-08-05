import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../setting/drawer.dart';
import '../controller/provider.dart';
import '../model/news.dart';
import 'utils/utils.dart';
import 'widget/category.dart';
import 'widget/selected_country.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({super.key});

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  late NewsProvider newsProvider;
  String countryName = 'India';
  String? category;

  countryNameFind() async {
    final data = await SelectedCountry(context: context).showListOfCountry();
    if (data != null) {
      countryName = data['country_name'];
      await newsProvider.newsCountry(data['country_code']);
    }
    setState(() {});
  }

  @override
  void initState() {
    newsProvider = Provider.of<NewsProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newsProvider = Provider.of<NewsProvider>(context);
    return LayoutBuilder(
      builder: (context, sizeIs) {
        return Scaffold(
          drawer: sizeIs.maxWidth < ScreenSize.tab
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
              Row(
                children: [
                  if (sizeIs.maxWidth > ScreenSize.tab)
                    const AppDrawer(pagename: 'News'),
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 45, child: CategoryWidget()),
                        Divider(),
                        Expanded(child: NewsList())
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({
    super.key,
    this.temperature = false,
    this.news,
    this.web = false,
  });
  final bool temperature;
  final String? news;
  final bool web;

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late NewsTempProvider newsTempProvider;
  late NewsProvider newsProvider;
  final ScrollController controller = ScrollController();
  NewsModel? news;
  final int pageSize = 15;

  @override
  void initState() {
    super.initState();
    newsTempProvider = Provider.of<NewsTempProvider>(context, listen: false);
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!widget.temperature) {
        if (newsProvider.news == null) {
          await newsProvider.newsApiCall();
        }
      }
      // Todo :- This is for get api call without pre init app.
      // else {
      //   if (newsTempProvider.news == null) {
      //     print('get All ready');
      //   }
      // }
      controller.addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          if (widget.temperature) {
            newsTempProvider.newsFetchMore(widget.news!);
          } else {
            newsProvider.newsFetchMore();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newsProvider = Provider.of<NewsProvider>(context);
    newsTempProvider = Provider.of<NewsTempProvider>(context);
    if (widget.temperature) {
      news = newsTempProvider.news;
    } else {
      news = newsProvider.news;
    }
    if (news != null) {
      return Container(
        constraints: BoxConstraints(maxWidth: ScreenSize.mobile),
        child: Align(
          alignment: Alignment.center,
          child: ListView.separated(
            separatorBuilder: (context, index) => widget.web
                ? const SizedBox()
                : Divider(color: Colors.grey[100]),
            shrinkWrap: true,
            controller: controller,
            physics: const BouncingScrollPhysics(),
            itemCount: news!.articles?.length ?? 0,
            itemBuilder: (context, index) {
              if (news!.articles != null) {
                final article = news!.articles![index];
                return Card(
                  color: widget.web ? Colors.transparent : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: article.title != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (article.urlToImage is String) ...[
                                Image.network(
                                  article.urlToImage,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox(),
                                ),
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
                            if (!await canLaunchUrl(Uri.parse(article.url!))) {
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
                          Tools.push(context, WebViewNews(url: article.url!));
                        }
                      } else {
                        Tools.notify(context, 'No URL found');
                      }
                    },
                  ),
                );
              } else {
                return const Center(child: Text('article error'));
              }
            },
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
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
