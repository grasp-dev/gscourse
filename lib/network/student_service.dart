import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'constant.dart';
import 'user_service.dart';
import 'package:http/http.dart' as http;

Future<List<Student>> fetchStudent(int courseId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$studentCourse/$courseId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseStudent, response.body);
}

Future<List<Student>> fetchStudentByBus(int bId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$studentByBus/$bId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseStudent, response.body);
}

Future<Student> fetchStudentId(int id) async {
  String token = await getToken();

  final response = await http.get(
    Uri.parse('$studentId/$id'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    return Student.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ');
  }
}

// A function that converts a response body into a List<Photo>.
List<Student> parseStudent(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Student>((json) => Student.fromJson(json)).toList();
}

class Student {
  int? id;
  String? username;
  int? courseId;
  int? busId;
  String? name;
  String? lastname;
  String? phone;
  String? email;
  String? line;
  String? address;
  String? about;
  String? profile;
  String? banner;

  Student({
    this.id,
    this.username,
    this.courseId,
    this.busId,
    this.name,
    this.lastname,
    this.phone,
    this.email,
    this.line,
    this.address,
    this.about,
    this.profile,
    this.banner,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      username: json['username'],
      courseId: json['course_id'],
      busId: json['bus_id'],
      name: json['name'],
      lastname: json['lastname'],
      phone: json['phone'],
      email: json['email'],
      line: json['line'],
      address: json['address'],
      about: json['about'],
      profile: json['profile'],
      banner: json['banner'],
    );
  }
}
