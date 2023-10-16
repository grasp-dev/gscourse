import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'constant.dart';
import 'user_service.dart';
import 'package:http/http.dart' as http;

Future<List<Paper>> fetchPaperByCourse(int courseId) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$paperByCourse/$courseId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

Future<List<Paper>> fetchPaperLimit(int limit) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$paperLimit/$limit'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Paper> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<Paper>((json) => Paper.fromJson(json)).toList();
}

Future<Paper> fetchPaperId(int id) async {
  String token = await getToken();

  final response = await http.get(
    Uri.parse('$paperId/$id'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    return Paper.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ');
  }
}

class Paper {
  int? id;
  String? couresId;
  String? title;
  String? about;
  String? file;
  String? created;

  Paper({
    this.id,
    this.couresId,
    this.title,
    this.about,
    this.file,
    this.created,
  });

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'],
      couresId: json['coures_id'],
      title: json['title'],
      about: json['about'],
      file: json['file'],
      created: json['created_at'],
    );
  }
}
