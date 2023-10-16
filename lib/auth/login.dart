import 'package:gscourse/network/api_response.dart';
import 'package:gscourse/models/user.dart';
import 'package:gscourse/network/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scr/app.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(username.text, password.text);
    if (response.errors == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.errors}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setInt('courseId', user.cousrId ?? 0);
    await pref.setString('profile', user.profile ?? '');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(30),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo-fill.png'),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: username,
                      validator: (val) =>
                          val!.isEmpty ? '* ระบุบัญชีผู้ใช้' : null,
                      decoration: const InputDecoration(
                        labelText: 'บัญชีผู้ใช้',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Kanit'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      validator: (val) =>
                          val!.isEmpty ? '* ระบุรหัสผ่าน' : null,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Kanit'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        padding: MaterialStateProperty.resolveWith(
                          (states) => const EdgeInsets.all(10),
                        ),
                      ),
                      child: Text(
                        loading ? 'กำลังโหลด' : 'เข้าสู่ระบบ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
