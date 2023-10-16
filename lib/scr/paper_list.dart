import 'package:gscourse/network/paper_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../network/constant.dart';
import 'app.dart';

class PaperListPage extends StatefulWidget {
  const PaperListPage({super.key});

  @override
  State<PaperListPage> createState() => _PaperPageState();
}

class _PaperPageState extends State<PaperListPage> {
  int courseId = 0;

  Future<void> loadCourseId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      courseId = (prefs.getInt('courseId') ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    loadCourseId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Paper>>(
          future: fetchPaperByCourse(courseId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PaperContent(paper: snapshot.data!);
            } else if (snapshot.hasError) {
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
}

PreferredSizeWidget customAppBar() {
  return AppBar(
    title: const Text('รายการเอกสาร'),
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

class PaperContent extends StatelessWidget {
  const PaperContent({super.key, required this.paper});

  final List<Paper> paper;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paper.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Icon(
                    Icons.download_for_offline,
                    size: 70,
                    color: Color.fromARGB(255, 201, 180, 214),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textSubtitle('${paper[index].title}'),
                      Text('${paper[index].about}'),
                    ],
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      //You can download a single file
                      FileDownloader.downloadFile(
                          url: '$baseUrl/${paper[index].file}',
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
            const SizedBox(height: 10),
            const Divider(),
          ],
        );
      },
    );
  }
}
