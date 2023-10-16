import 'package:flutter/material.dart';

import '../network/constant.dart';
import '../network/student_service.dart';
import 'app.dart';
import 'student_detail.dart';

class BusStudent extends StatelessWidget {
  const BusStudent({super.key, this.bId});

  final int? bId;

  @override
  Widget build(BuildContext context) {
    Future<List<Student>> futureStudent = fetchStudentByBus(bId!);

    return Scaffold(
      appBar: customAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
        children: [
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Title(
                  color: Colors.black,
                  child: textTitle('รายชื่อนักเรียน'),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: textBody('ครบแล้ว'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Import Students Box
          studentList(futureStudent),
        ],
      ),
    );
  }
}

Widget studentList(Future<List<Student>> futureStudent) {
  return FutureBuilder(
    future: futureStudent,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            for (var i = 0; i < snapshot.data!.length; i++)
              InkWell(
                child: Container(
                  width: double.infinity,
                  height: 80,
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFFD6D6D6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          '$baseUrl${snapshot.data![i].profile}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textSubtitle('${snapshot.data![i].name}'),
                                  Text('${snapshot.data![i].lastname}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textBody('มาแล้ว'),
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                            ),
                          ],
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
                          StudentDetail(postId: snapshot.data![i].id),
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

PreferredSizeWidget customAppBar(context) {
  return AppBar(
    title: const Text('รายชื่อนักเรียน'),
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
