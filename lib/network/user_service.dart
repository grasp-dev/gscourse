import 'dart:convert';

import 'package:gscourse/network/api_response.dart';
import 'package:gscourse/network/constant.dart';
import 'package:gscourse/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Login
Future<ApiResponse> login(String username, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURl),
        headers: {'Accept': 'application/json'},
        body: {'username': username, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.formJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors = errors[errors.keys.elementAt(0)[0]];
        break;
      case 403:
        apiResponse.errors = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.errors = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.errors = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register(
    String username, String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURl),
      headers: {'Accept': 'application/json'},
      body: {
        'username': username,
        'email': email,
        'name': name,
        'password': password,
        'password_comfirm': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.formJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors = errors[errors.keys.elementAt(0)[0]];
        break;
      default:
        apiResponse.errors = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.errors = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.formJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.errors = unauthorized;
        break;
      default:
        apiResponse.errors = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.errors = serverError;
  }

  return apiResponse;
}

// Get Token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
