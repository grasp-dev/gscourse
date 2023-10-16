import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../network/constant.dart';
import '../network/news_service.dart';
import 'app.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key, this.newsId});

  final int? newsId;
  @override
  State<NewsDetail> createState() => _NewsDetailState(newsId);
}

class _NewsDetailState extends State<NewsDetail> {
  _NewsDetailState(this.newsId);

  final int? newsId;

  late Future<News> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsId(newsId!);
    // print(futureNews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: FutureBuilder<News>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return boxNews(news: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget boxNews({required News news}) {
    return ListView(
      children: [
        Image.network(
          '$baseUrl${news.thumbnail}',
          fit: BoxFit.cover,
        ),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                textTitle('${news.title}'),
                Text(
                  '${news.created}'.substring(1, 10),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                HtmlWidget('${news.desc}'),
              ],
            ),
          ),
        )
      ],
    );
  }
}

PreferredSizeWidget customAppBar(context) {
  return AppBar(
    title: SizedBox(
      child: Image.asset('assets/images/logo.png'),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        },
        icon: const Icon(Icons.home),
        iconSize: 30,
        tooltip: 'หน้าหลัก',
      ),
    ],
    backgroundColor: const Color(0xFF7C0EC0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
  );
}
