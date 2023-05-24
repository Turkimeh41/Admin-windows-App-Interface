// ignore_for_file: non_constant_identifier_names, constant_identifier_names, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:chalkdart/chalk.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world/Exception/exceptions.dart' as exe;

class Users with ChangeNotifier {
  String idToken = '';
  String docID = '';
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  void adminUpdate(String idToken, String docID) {
    log('Updating admin data for users..');
    this.idToken = idToken;
    this.docID = docID;
  }

  Future<void> fetchUsers() async {
    List<User> loadedUsers = [];
    final userURL = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Users');
    final enabledURL = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/User_Enabled');

    final futures = await Future.wait([
      http.get(userURL, headers: {'Authorization': 'Bearer $idToken'}),
      http.get(enabledURL, headers: {'Authorization': 'Bearer $idToken'})
    ]);
    final userResponse = futures[0];
    final enabledResponse = futures[1];
    if (userResponse.statusCode != 200 || enabledResponse.statusCode != 200) {
      throw Exception('Failed to fetch documents');
    }

    if ((json.decode(userResponse.body))['documents'] == null) {
      log(chalk.red.bold('No users has registered in the app.'));
      return;
    }
    log(chalk.green.bold('Storing users...'));
    final userDocs = (json.decode(userResponse.body))['documents'] as List<dynamic>;
    final enabledDocs = (json.decode(enabledResponse.body))['documents'] as List<dynamic>;
    for (int i = 0; i < userDocs.length; i++) {
      final userData = userDocs[i]['fields'] as Map<String, dynamic>;
      final enabledData = enabledDocs[i]['fields'] as Map<String, dynamic>;
      final id = (userDocs[i]['name'] as String).split('/').last;
      final username = (userData['username'] as Map<String, dynamic>).values.first;

      var balancePlaceHolder = (userData['balance'] as Map<String, dynamic>).values.first;
      //CORRECT WAY !!!, IT'S ALWAYS STORED AS doubleValue, but it could be an int when retrived, so checking if it's a double or int, is required
      late double balance;
      if (balancePlaceHolder is double) {
        balance = balancePlaceHolder;
      } else if (balancePlaceHolder is int) {
        balance = balancePlaceHolder.toDouble();
      } else {
        balance = double.parse(balancePlaceHolder);
      }
      final phone = (userData['phone'] as Map<String, dynamic>).values.first;

      final gender = int.parse((userData['gender'] as Map<String, dynamic>).values.first);

      final enabled = (enabledData['enabled'] as Map<String, dynamic>).values.first;
      final imgURL = (userData['imgURL'] as Map<String, dynamic>).values.first;
      final email = (userData['email'] as Map<String, dynamic>).values.first;

      final timestamp = (userData['registered'] as Map<String, dynamic>).values.first;

      final register_date = DateTime.parse(timestamp);

      loadedUsers.add(User(id: id, imgURL: imgURL, gender: gender, username: username, balance: balance, enabled: enabled, email: email, phone: phone, register_date: register_date));
    }
    log(chalk.blueBright.bold('Users should be stored!'));
    _users = loadedUsers;
  }

  List<User> filter(String search, int filter, int sort, bool ascending) {
    List<User> filteredUsers = users.where((element) {
      switch (filter) {
        case 0:
          return element.id.toLowerCase().startsWith(search.toLowerCase());
        case 1:
          return element.username.toLowerCase().startsWith(search.toLowerCase());
        case 2:
          return element.phone.startsWith(search);
        case 3:
          return element.email.toLowerCase().startsWith(search.toLowerCase());
        default:
          return false;
      }
    }).toList();

    if (ascending) {
      switch (sort) {
        case 0:
          filteredUsers.sort((a, b) => a.id.compareTo(b.id));
          break;
        case 1:
          filteredUsers.sort((a, b) => a.username.compareTo(b.username));
          break;
        case 2:
          filteredUsers.sort((a, b) => b.register_date.compareTo(a.register_date));
          break;
        case 3:
          filteredUsers.sort((a, b) => a.enabled ? -1 : 1);
          break;
      }
    } else {
      switch (sort) {
        case 0:
          filteredUsers.sort((a, b) => b.id.compareTo(a.id));
          break;
        case 1:
          filteredUsers.sort((a, b) => b.username.compareTo(a.username));
          break;
        case 2:
          filteredUsers.sort((a, b) => a.register_date.compareTo(b.register_date));
          break;
        case 3:
          filteredUsers.sort((a, b) => b.enabled ? -1 : 1);
          break;
      }
    }

    return filteredUsers;
  }

  List<User> latest() {
    List<User> latestUsers = [];
    _users.sort((a, b) => b.register_date.compareTo(a.register_date));
    for (int i = 0; i < _users.length; i++) {
      latestUsers.add(_users[i]);

      if (i + 1 == 10) {
        break;
      }
    }
    return latestUsers;
  }

  Future<void> addUser(String first_name, String last_name, String email, String phone, String username, String password, int gender) async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/restAddUser');
    final response = await http.post(url,
        body: {"username": username, 'first_name': first_name, "last_name": last_name, "email": email, "phone": phone, "gender": gender.toString(), "password": password},
        headers: {'Authorization': 'Bearer $idToken'});
    if (response.statusCode != 200) {
      throw exe.UnknownException('INTERNAL', 'Internal server Error');
    }
    final Map<String, dynamic> result = jsonDecode(response.body);

    _users.add(User(id: result['id'], imgURL: null, username: username, balance: 0, gender: gender, enabled: true, email: email, phone: phone, register_date: DateTime.now()));
    log('successful add');
    notifyListeners();
  }

  Future<void> removeUser(String userID) async {
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Users/$userID');
    late User user;
    //search for user store the object reference in user to check if a user has an image to remove
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].id == userID) {
        user = _users[i];
        _users.removeAt(i);
        break;
      }
    }

    final response = await http.delete(url, headers: {'Authorization': 'Bearer $idToken'});
    //deleting user_engaged stream data

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      log(error);
      log('Error removal of user, please recheck logs.');
    }
    notifyListeners();
  }

  Future<void> switchUserStatus(String userID) async {
    final enabled = changeGetStatus(userID);
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/User_Enabled/$userID',
        {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng', 'updateMask.fieldPaths': 'enabled'});

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    final body = jsonEncode(<String, dynamic>{
      'fields': {
        'enabled': {
          'booleanValue': enabled,
        },
      },
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Field Status in document $userID in collection Users has been updated to $enabled');
      } else {
        print('Error occurred while updating field. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while updating field: $error');
    }
    notifyListeners();
  }

//change user status in the client
  bool changeGetStatus(String id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        users[i].enabled = !users[i].enabled;
        return users[i].enabled;
      }
    }
    throw Exception('couldn\'nt found the id');
  }

  bool getStatus(String id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i].enabled;
      }
    }
    throw Exception('could\'nt found the id');
  }
}
