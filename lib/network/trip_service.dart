import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'constant.dart';
import 'user_service.dart';
import 'package:http/http.dart' as http;

Future<List<Trip>> fetchTripByCourse(int courseId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$tripByCourse/$courseId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // print(response.body);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

Future<List<Trip>> fetchTripLimit(int limit) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$tripLimit/$limit'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Trip> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Trip>((json) => Trip.fromJson(json)).toList();
}

Future<Trip> fetchTripId(int id) async {
  String token = await getToken();

  final response = await http.get(
    Uri.parse('$tripId/$id'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    return Trip.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ');
  }
}

class Trip {
  int? id;
  int? courseId;
  int? busId;
  String? title;
  String? cTitle;
  String? desc;
  String? thumbnail;
  String? created;

  Trip({
    this.id,
    this.courseId,
    this.busId,
    this.title,
    this.cTitle,
    this.desc,
    this.thumbnail,
    this.created,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      courseId: json['course_id'],
      busId: json['b_id'],
      title: json['title'],
      cTitle: json['c_title'],
      desc: json['desc'],
      thumbnail: json['thumbnail'],
      created: json['created_at'],
    );
  }
}
