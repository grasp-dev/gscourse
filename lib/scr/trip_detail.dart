import 'package:flutter/material.dart';

import '../network/bus_service.dart';
import '../network/constant.dart';
import '../network/trip_service.dart';
import 'app.dart';
import 'bus_student.dart';

class TripDetail extends StatefulWidget {
  const TripDetail({super.key, this.tId});

  final int? tId;

  @override
  State<TripDetail> createState() => _TripDetailState(tId);
}

class _TripDetailState extends State<TripDetail> {
  _TripDetailState(this.tId);

  int? tId;
  late Future<Trip> futureTrip;
  late Future<List<Bus>> futureBus;

  @override
  void initState() {
    super.initState();
    futureTrip = fetchTripId(tId!);
    futureBus = fetchBusByTrip(tId!);
    // print(futureBus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
        children: [
          Center(
            child: textTitle('รายการรถนำเที่ยว'),
          ),
          const Center(
            child: Text(
              '*กดที่รายการรถเพื่อดูรายชื่อนักเรียน',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          // Load Bus in Trip
          listBus(context, futureBus),

          // Import Students Box
          FutureBuilder<Trip>(
            future: futureTrip,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return listBox(data: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget listBox({required Trip data}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Card(
          // color: const Color.fromARGB(255, 255, 227, 144),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                textTitle('รายละเอียดทริป'),
                dataRow('คอร์สเรียน', ' ${data.cTitle}'),
                dataRow('ชื่อ', ' ${data.title}'),
                dataRow('รายละเอียด', ' ${data.desc}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget listBus(context, Future<List<Bus>> futureBus) {
  Size size = MediaQuery.of(context).size;
  double width50 = size.width * 0.449;
  return FutureBuilder(
    future: futureBus,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Wrap(
          spacing: 10,
          children: [
            for (var i = 0; i < snapshot.data!.length; i++)
              SizedBox(
                width: width50,
                child: Card(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text('${snapshot.data![i].bus}'),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Image.network(
                            '$baseUrl${snapshot.data![i].thumbnail}',
                            fit: BoxFit.contain,
                            height: 50,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BusStudent(bId: snapshot.data![i].id),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      } else if (snapshot.hasError) {
        // print(snapshot.error);
        return Center(
          child: Text('${snapshot.error}'),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

Widget dataRow(String fields, String dataText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          '$fields : ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: Text(
            dataText,
          ),
        ),
      ),
    ],
  );
}

PreferredSizeWidget customAppBar(context) {
  return AppBar(
    title: const Text('ข้อมูลทริปท่องเที่ยว'),
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
