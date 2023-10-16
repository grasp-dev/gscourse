import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'constant.dart';
import 'user_service.dart';
import 'package:http/http.dart' as http;

Future<List<Bus>> fetchBusByTrip(int tId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$busByTrip/$tId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // print(response.body);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Bus> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Bus>((json) => Bus.fromJson(json)).toList();
}

Future<Bus> fetchBusId(int id) async {
  String token = await getToken();

  final response = await http.get(
    Uri.parse('$busId/$id'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    return Bus.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ');
  }
}

class Bus {
  int? id;
  int? courseId;
  int? tripId;
  String? bus;
  String? about;
  String? thumbnail;
  String? created;

  Bus({
    this.id,
    this.courseId,
    this.tripId,
    this.bus,
    this.about,
    this.thumbnail,
    this.created,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      courseId: json['course_id'],
      tripId: json['trip_id'],
      bus: json['bus'],
      about: json['about'],
      thumbnail: json['thumbnail'],
      created: json['created_at'],
    );
  }
}
