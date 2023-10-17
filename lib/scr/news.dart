import 'package:flutter/material.dart';

import '../network/constant.dart';
import '../network/news_service.dart';
import 'app.dart';
import 'news_detail.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: FutureBuilder<List<News>>(
          future: fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NewsList(news: snapshot.data!);
            } else if (snapshot.hasError) {
              // print(snapshot.error);
              return const Center(
                child: Text('เกิดข้อผิดพลาดในการเชื่อมต่อ'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar() {
    return AppBar(
      title: const Text('ข่าวสาร & กิจกรรม'),
      centerTitle: true,
      backgroundColor: const Color(0xFF7C0EC0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({super.key, required this.news});

  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        // return Image.network(imgUrl + news[index].thumbnail);
        // return Text(news[index].thumbnail);
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: news[index].thumbnail != '' &&
                          news[index].thumbnail != null
                      ? Image.network(
                          '$baseUrl${news[index].thumbnail}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 80,
                        )
                      : Image.asset(
                          'assets/images/default-news.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 80,
                        ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textSubtitle('${news[index].title}'),
                        Text('${news[index].shortdesc}'),
                        // Html(data: news[index].desc),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsDetail(newsId: news[index].id)),
            );
          },
        );
      },
    );
  }
}
