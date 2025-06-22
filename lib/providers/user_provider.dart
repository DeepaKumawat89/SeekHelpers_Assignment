import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/user_model.dart';

//------------------------------------ User Provider Class ------------------------------------//
class UserProvider with ChangeNotifier {
  //------------------------------------ State Variables ------------------------------------//
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  //------------------------------------ Getters ------------------------------------//
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //------------------------------------ Fetch Users Method ------------------------------------//
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      //------------------------------------ API Call ------------------------------------//
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please check your internet connection.');
        },
      );

      //------------------------------------ Response Handling ------------------------------------//
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        print('Parsed JSON data: $jsonData');

        _users = jsonData.map((e) => User.fromJson(e)).toList();
        print('Converted users: ${_users.length}');
        _error = null;
      } else {
        _error = "Server error: ${response.statusCode}. Please try again later.";
        print('Error: $_error');
      }
    }
    //------------------------------------ Error Handling ------------------------------------//
    on SocketException catch (e) {
      print('Socket Exception: $e');
      _error = "No internet connection. Please check your network settings and try again.";
    } on HttpException catch (e) {
      print('HTTP Exception: $e');
      _error = "Couldn't retrieve the users data. Please try again later.";
    } on FormatException catch (e) {
      print('Format Exception: $e');
      _error = "Invalid response format. Please try again later.";
    } on TimeoutException catch (e) {
      print('Timeout Exception: $e');
      _error = "Connection timed out. Please check your internet connection.";
    } catch (e) {
      print('Unexpected error: $e');
      _error = "An unexpected error occurred. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //------------------------------------ Add User Method ------------------------------------//
  void addUser(User user) {
    final newUser = User(
      id: _users.length + 1,
      name: user.name,
      email: user.email,
      phone: user.phone,
    );
    _users.add(newUser);
    notifyListeners();
  }
}
