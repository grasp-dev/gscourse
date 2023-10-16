import 'package:flutter/material.dart';
import 'package:splash_view/splash_view.dart';

import 'scr/loading.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Kanit',
      ),
      home: SplashView(
        backgroundColor: Colors.purple,
        // loadingIndicator: const RefreshProgressIndicator(),
        logo: Image.asset('assets/images/logo.png'),
        done: Done(const MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Loading(),
    );
  }
}
