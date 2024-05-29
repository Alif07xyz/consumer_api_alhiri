import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _users =
          (data['data'] as List).map((user) => User.fromJson(user)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserById(int id) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> addUser(String name, String job) async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'job': job,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      // Create a User object from the response data
      User newUser = User(
        id: int.parse(data['id']), // Use id from response
        email: '', // Email is not provided in the creation API response
        firstName: name
            .split(' ')[0], // Assuming first name is the first word of the name
        lastName: name.split(' ').length > 1
            ? name.split(' ')[1]
            : '', // Assuming last name is the second word of the name
        avatar:
            'https://reqres.in/img/faces/1-image.jpg', // Use a placeholder avatar
      );
      _users.add(newUser);
      notifyListeners();
    } else {
      print('Error adding user: ${response.body}');
      throw Exception('Failed to create user');
    }
  }
}
