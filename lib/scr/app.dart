import 'package:gscourse/auth/login.dart';
import 'package:gscourse/network/user_service.dart';
import 'package:gscourse/scr/student_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/constant.dart';
import 'contact.dart';
import 'home.dart';
import 'news.dart';
import 'news_detail.dart';
import 'paper.dart';
import 'student.dart';
import 'student_detail.dart';
import 'trip.dart';
import 'trip_detail.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int uId = 0;
  String profile = '';

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uId = (prefs.getInt('userId') ?? 0);
      profile = (prefs.getString('profile') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/student': (context) => const StudentPage(),
        '/student-detail': (context) => const StudentDetail(),
        '/student-list': (context) => const StudentListPage(),
        '/news': (context) => const NewsPage(),
        '/news-detail': (context) => const NewsDetail(),
        '/trip': (context) => const TripPage(),
        '/trip-detail': (context) => const TripDetail(),
        '/dashboard': (context) => const Dashboard(),
      },
      theme: ThemeData(
        fontFamily: 'Kanit',
      ),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: customAppBar(context, uId, profile),
          body: const TabBarView(
            children: [
              HomePage(),
              StudentPage(),
              TripPage(),
              PaperPage(),
              ContactPage(),
            ],
          ),
          bottomNavigationBar: footerNav(),
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar(context, int uId, String? profile) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StudentDetail(postId: uId),
            ),
          );
        },
        child: profile != "" && profile != null
            ? Image.network(
                '$baseUrl$profile',
                cacheHeight: 40,
              )
            : Image.asset(
                'assets/images/profile.png',
                cacheHeight: 40,
              ),
      ),
      title: SizedBox(
        child: Image.asset('assets/images/logo.png'),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false));
          },
          icon: const Icon(Icons.logout),
          iconSize: 30,
          tooltip: 'ออกจากระบบ',
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
}

Widget footerNav() {
  return const TabBar(
    labelColor: Colors.purple,
    unselectedLabelColor: Colors.grey,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorPadding: EdgeInsets.all(5.0),
    indicatorColor: Colors.blue,
    tabs: [
      Tab(
        text: "หน้าหลัก",
        icon: Icon(Icons.home_outlined),
      ),
      Tab(
        text: "นักเรียน",
        icon: Icon(Icons.person_outlined),
      ),
      Tab(
        text: "ทริป",
        icon: Icon(Icons.tour_outlined),
      ),
      Tab(
        text: "เอกสาร",
        icon: Icon(Icons.download_outlined),
      ),
      Tab(
        text: "ติดต่อ",
        icon: Icon(Icons.language_outlined),
      ),
    ],
  );
}

Text textTitle(String str) {
  return Text(
    str,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

Text textSubtitle(String str) {
  return Text(
    str,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

Text textBody(String str) {
  return Text(
    str,
    style: const TextStyle(
      fontSize: 16,
    ),
  );
}
