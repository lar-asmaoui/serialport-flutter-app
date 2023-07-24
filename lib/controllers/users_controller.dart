import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weight_calculator/api/api_connect.dart';
import 'package:weight_calculator/models/user.dart';

class UsersController extends ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  Future<void> loadUsers(String id) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnect.loadUsers),
        body: {
          'id': id,
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          for (var user in (responseData['users'] as List)) {
            final newUser = User.fromJson(user);
            final existingUserIndex =
                _users.indexWhere((u) => u.id == newUser.id);
            if (existingUserIndex != -1) {
              _users[existingUserIndex] = newUser;
            } else {
              _users.add(newUser);
            }
          }
          notifyListeners();
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> create(String username, String password, String role) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المستخدم وكلمة المرور فارغين');
    }

    User user = User(
      username: username,
      password: password,
      role: role,
    );

    try {
      final response = await http.post(
        Uri.parse(ApiConnect.create),
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

  Future<void> delete(String id) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConnect.deleteUser),
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception(responseData['message']);
        } else {
          _users.removeWhere((user) => user.id.toString() == id);
          notifyListeners();
        }
      } else {
        throw Exception('Failed to delete user.');
      }
    } catch (error) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<void> updateAllInfo(
      String id, String username, String password, String role) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المستخدم وكلمة المرور فارغين');
    }

    try {
      final response =
          await http.post(Uri.parse(ApiConnect.updateAllInfo), body: {
        'id': id,
        'username': username,
        'password': password,
        'role': role,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception(responseData['message']);
        } else {
          // final existingUserIndex =
          //     _users.indexWhere((user) => user.id.toString() == id);
          // if (existingUserIndex != -1) {
          //   _users[existingUserIndex] = user;
          // }
          notifyListeners();
        }
      } else {
        print(jsonDecode(response.body));
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
