import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_calculator/api/api_connect.dart';
import 'package:weight_calculator/models/user.dart';
import 'package:http/http.dart' as http;

class AuthController extends ChangeNotifier {
  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المستخدم وكلمة المرور فارغين');
    }
    try {
      final response =
          await http.post(Uri.parse(await ApiConnect.login), body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
              "currentUser", jsonEncode(responseData['userData']));
        } else {
          throw Exception('اسم المستخدم أو كلمة المرور غير صحيحة');
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المستخدم وكلمة المرور فارغين');
    }

    User user = User(
      username: username,
      password: password,
      role: 'admin',
    );

    try {
      final response = await http.post(
        Uri.parse(await ApiConnect.create),
        body: user.toJson(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to create user.');
      }
    } catch (error) {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('currentUser');
  }

  Future<void> updateProfile(int? id, String username, String password,
      String? confirmPassword) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المستخدم وكلمة المرور فارغين');
    }

    if (password != confirmPassword) {
      throw Exception('كلمة المرور غير متطابقة');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConnect.updateUser as String),
        body: {
          'id': id.toString(),
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception(responseData['message']);
        } else {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
            "currentUser",
            jsonEncode(
              responseData['userData'],
            ),
          );
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update user.');
      }
    } catch (error) {
      throw Exception('Failed to update user.');
    }
  }
}
