import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/constant.dart';
import '../network/student_service.dart';
import 'app.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({super.key, this.postId});

  final int? postId;
  @override
  State<StudentDetail> createState() => _StudentDetailState(postId);
}

class _StudentDetailState extends State<StudentDetail> {
  _StudentDetailState(this.postId);

  final int? postId;

  late Future<Student> futureStudent;

  @override
  void initState() {
    super.initState();
    futureStudent = fetchStudentId(postId!);
    // print(futureStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 227, 144),
      appBar: customAppBar(context),
      body: FutureBuilder<Student>(
        future: futureStudent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BoxDetail(student: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class BoxDetail extends StatelessWidget {
  const BoxDetail({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        SizedBox(
          width: double.infinity,
          height: 100,
          child: avatarPrifle(
            student.profile != null
                ? '$baseUrl${student.profile}'
                : 'assets/images/student-profile.jpg',
          ),
        ),
        const SizedBox(height: 16),
        // Student Content
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 255, 227, 144),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dataRow('ชื่อ', '${student.name}'),
                      dataRow('นามสกุล', '${student.lastname}'),
                      dataRow('อีเมล', '${student.phone}'),
                      dataRow('อีเมล', '${student.email}'),
                      dataRow('ไลน์ไอดี', '${student.line}'),
                      dataRow('ที่อยู่', '${student.address}'),
                      dataRow('เกี่ยวกับ', '${student.about}'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shadowColor: Colors.greenAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  'assets/images/icons/phone.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('${student.phone}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shadowColor: Colors.greenAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  'assets/images/icons/mail.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('${student.email}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shadowColor: Colors.greenAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {
              launchUrl(Uri.parse('https://line.me/ti/p/${student.line}'));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  'assets/images/icons/line.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('${student.line}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dataRow(String fields, String dataText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$fields : ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(dataText),
          ),
        ),
      ],
    );
  }

  Widget avatarPrifle(String profile) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey,
            spreadRadius: 2,
          )
        ],
      ),
      child: CircleAvatar(
        radius: (52),
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(profile),
        ),
      ),
    );
  }
}

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    ),
    title: SizedBox(
      child: Image.asset('assets/images/logo.png'),
    ),
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
