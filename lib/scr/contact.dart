import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textTitle('ติดต่อเรา'),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16.0),
              decoration: contactBox(),
              child: Column(
                children: [
                  textTitle('ที่อยู่'),
                  textBody('555 คลองสาน คลองสาน กรุงเทพฯ 10600'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16.0),
              decoration: contactBox(),
              child: Column(
                children: [
                  textTitle('เว็บไซต์'),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse('https://www.grasp.asia')),
                    child: const Text(
                      'www.grasp.asia',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16.0),
              decoration: contactBox(),
              child: Column(
                children: [
                  textTitle('เบอร์โทร'),
                  textBody('098 765 4123'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16.0),
              decoration: contactBox(),
              child: Column(
                children: [
                  textTitle('ไลน์ไอดี'),
                  textBody('098 765 4123'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration contactBox() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xffDDDDDD),
          blurRadius: 6.0,
          spreadRadius: 2.0,
          offset: Offset(0.0, 0.0),
        )
      ],
    );
  }
}
