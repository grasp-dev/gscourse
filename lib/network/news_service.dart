import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'constant.dart';
import 'user_service.dart';
import 'package:http/http.dart' as http;

Future<List<News>> fetchNews() async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse(newsURl),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseNews, response.body);
}

Future<List<News>> fetchNewsLimit(int limit) async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse('$newsLimit/$limit'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseNews, response.body);
}

// A function that converts a response body into a List<Photo>.
List<News> parseNews(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();

  return parsed.map<News>((json) => News.fromJson(json)).toList();
}

Future<News> fetchNewsId(int id) async {
  String token = await getToken();

  final response = await http.get(
    Uri.parse('$newsId/$id'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(response.body);
    return News.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ');
  }
}

class News {
  int? id;
  String? title;
  String? shortdesc;
  String? desc;
  String? thumbnail;
  String? created;

  News({
    this.id,
    this.title,
    this.shortdesc,
    this.desc,
    this.thumbnail,
    this.created,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      shortdesc: json['shortdesc'],
      desc: json['desc'],
      thumbnail: json['thumbnail'],
      created: json['created_at'],
    );
  }
}
