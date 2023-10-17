import 'package:gscourse/network/paper_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../network/constant.dart';
import '../network/news_service.dart';
import 'app.dart';
import 'news.dart';
import 'news_detail.dart';
import 'paper_list.dart';
import 'student_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<News>> fetchNews = fetchNewsLimit(2);
  Future<List<Paper>> fetchPaper = fetchPaperLimit(2);

  @override
  void initState() {
    super.initState();
    // print(fetchNews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textSubtitle('DIRECTORY'),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Image.asset(
                'assets/images/directory.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned.fill(
                right: 25,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/student-list');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const StudentListPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.all(10),
                      ),
                    ),
                    child: const Text(
                      'ทั้งหมด',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Section News
          sectionTitle(
            context,
            'ข่าวสาร และกิจกรรม',
            const NewsPage(),
          ),
          listNews(fetchNews),
          // End Section News

          // Section Paper
          const SizedBox(height: 32),
          sectionTitle(
            context,
            'เอกสารดาวน์โหลด',
            const PaperListPage(),
          ),
          const SizedBox(height: 16),
          homePaper(fetchPaper),
        ],
      ),
    );
  }
}

Widget sectionTitle(context, title, routePage) {
  return Row(
    children: [
      Expanded(
        flex: 7,
        child: Title(
          color: Colors.black,
          child: textSubtitle(title),
        ),
      ),
      Expanded(
        flex: 3,
        child: InkWell(
          child: const Text(
            'ทั้งหมด',
            textAlign: TextAlign.end,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => routePage,
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget listNews(Future<List<News>> fetchNews) {
  return FutureBuilder(
    future: fetchNews,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            for (var i = 0; i < snapshot.data!.length; i++)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: snapshot.data![i].thumbnail != '' &&
                                snapshot.data![i].thumbnail != null
                            ? Image.network(
                                '$baseUrl${snapshot.data![i].thumbnail}',
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
                              textSubtitle('${snapshot.data![i].title}'),
                              Text('${snapshot.data![i].shortdesc}'),
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
                      builder: (context) =>
                          NewsDetail(newsId: snapshot.data![i].id),
                    ),
                  );
                },
              ),
          ],
        );
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
  );
}

Widget homePaper(Future<List<Paper>> fetchPaper) {
  return FutureBuilder(
    future: fetchPaper,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            for (var i = 0; i < snapshot.data!.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.download_for_offline,
                      size: 70,
                      color: Color.fromARGB(255, 201, 180, 214),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textSubtitle('${snapshot.data![i].title}'),
                        Text('${snapshot.data![i].about}'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: () {
                        //You can download a single file
                        FileDownloader.downloadFile(
                            url: '$baseUrl/${snapshot.data![i].file}',
                            // name: ,
                            onProgress: (String? fileName, double? progress) {
                              print('FILE fileName HAS PROGRESS $progress');
                            },
                            onDownloadCompleted: (String? path) {
                              print('FILE DOWNLOADED TO PATH: $path');
                            },
                            onDownloadError: (String? error) {
                              print('DOWNLOAD ERROR: $error');
                            });
                      },
                      child: const Text('ดาวน์โหลด'),
                    ),
                  ),
                ],
              ),
          ],
        );
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
  );
}
