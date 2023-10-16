import 'package:gscourse/scr/student_detail.dart';
import 'package:flutter/material.dart';

import '../network/constant.dart';
import '../network/student_service.dart';
import 'app.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
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
    // print(courseId);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: FutureBuilder<List<Student>>(
          future: fetchStudent(courseId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StudentBox(student: snapshot.data!);
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

class StudentBox extends StatelessWidget {
  const StudentBox({super.key, required this.student});

  final List<Student> student;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: student.length,
      itemBuilder: (context, index) {
        return Container(
          width: 320,
          height: 100,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFD6D6D6)),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  '$baseUrl${student[index].profile}',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textSubtitle('${student[index].name}'),
                          Text('${student[index].lastname}'),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetail(postId: student[index].id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7D0EC0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        // padding: const EdgeInsets.fromLTRB(25, 14, 25, 15),
                      ),
                      child: const Text(
                        'ดูข้อมูล',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
