import 'package:gscourse/scr/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/constant.dart';
import '../network/trip_service.dart';
import 'app.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int cId = 0;

  Future<void> loadCourseId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cId = (prefs.getInt('courseId') ?? 0);
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
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Trip>>(
          future: fetchTripByCourse(cId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TripContent(data: snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
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

class TripContent extends StatelessWidget {
  const TripContent({super.key, required this.data});
  final List<Trip> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
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
                child:
                    data[index].thumbnail != '' && data[index].thumbnail != null
                        ? Image.network(
                            '$baseUrl${data[index].thumbnail}',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/default-trip.jpg',
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
                          textSubtitle('${data[index].title}'),
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
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TripDetail(tId: data[index].id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: Text(
                            "รายละเอียด",
                          ),
                        ),
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
