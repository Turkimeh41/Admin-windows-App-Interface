// ignore_for_file: non_constant_identifier_names, constant_identifier_names, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';
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
    log('updating admin data for users');
    this.idToken = idToken;
    this.docID = docID;
  }

  Future<void> fetchUsers() async {
    List<User> loadedUsers = [];
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Users');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $idToken'});
    if (response.statusCode != 200) {
      throw Exception('Failed to read document');
    }
    log('Storing users...');
    if ((json.decode(response.body))['documents'] == null) {
      log('no user data');
      return;
    }
    final data = (json.decode(response.body))['documents'] as List<dynamic>;
    for (int i = 0; i < data.length; i++) {
      final document = data[i]['fields'] as Map<String, dynamic>;
      final id = (data[i]['name'] as String).split('/').last;
      final username = document['username']['stringValue'] as String;

      var balancePlaceHolder = (document['balance'] as Map<String, dynamic>).values.first;
      //CORRECT WAY !!!, IT'S ALWAYS STORED AS doubleValue, but it could be an int when retrived, so checking if it's a double or int, is required
      late double balance;
      if (balancePlaceHolder is double) {
        balance = balancePlaceHolder;
      } else if (balancePlaceHolder is int) {
        balance = balancePlaceHolder.toDouble();
      } else {
        balance = double.parse(balancePlaceHolder);
      }
      final phone = document['phone_number']['stringValue'] as String;

      final gender = int.parse((document['gender'] as Map<String, dynamic>).values.first);

      final status = (document['status']['booleanValue']) as bool;
      final img_link = document['imguser_link']['stringValue'] as String;
      final email = document['email_address']['stringValue'] as String;

      final timestamp = document['registered']['timestampValue'];

      final register_date = DateTime.parse(timestamp);

      loadedUsers
          .add(User(id: id, img_link: img_link, gender: gender, username: username, balance: balance, status: status, email: email, phone: phone, register_date: register_date));
    }
    print('Users should be stored!');
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
          filteredUsers.sort((a, b) => a.status ? -1 : 1);
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
          filteredUsers.sort((a, b) => b.status ? -1 : 1);
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
        body: {"username": username, 'first_name': first_name, "last_name": last_name, "emailAddress": email, "number": phone, "gender": gender.toString(), "password": password},
        headers: {'Authorization': 'Bearer $idToken'});
    if (response.statusCode != 200) {
      throw exe.UnknownException('INTERNAL', 'Internal server Error');
    }
    final Map<String, dynamic> result = jsonDecode(response.body);

    _users.add(User(id: result['id'], img_link: 'null', username: username, balance: 0, gender: gender, status: true, email: email, phone: phone, register_date: DateTime.now()));
    log('successful add');
    notifyListeners();
  }

  Future<void> removeUser(String userID) async {
    final url1 = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Users/$userID');
    final url2 = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/User_Engaged/$userID');
    late User user;
    //search for user store the object reference in user to check if a user has an image to remove
    for (int i = 0; i < _users.length; i++) {
      if (_users[i].id == userID) {
        user = _users[i];
        _users.removeAt(i);
        break;
      }
    }

    final response = await Future.wait([
      //first url deletes any user storage
      //second deletes user's instance in firebase firestore
      http.delete(url1, headers: {'Authorization': 'Bearer $idToken'}),
      //deleting user_engaged stream data
      http.delete(url2, headers: {'Authorization': 'Bearer $idToken'})
    ]);

    if (response[0].statusCode != 200) {
      final error = jsonDecode(response[0].body);
      log(error);
      log('Error from the removal of the photo image, please recheck the firebase function logs of the deleteImage for more details.');
    } else if (response[1].statusCode != 200) {
      throw exe.UnknownException('unknown', 'error from the rest API delete request');
    }

    notifyListeners();
  }

  Future<void> switchUserStatus(String userID) async {
    final status = changeGetStatus(userID);
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Users/$userID',
        {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng', 'updateMask.fieldPaths': 'status'});

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    final body = jsonEncode(<String, dynamic>{
      'fields': {
        'status': {
          'booleanValue': status,
        },
      },
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Field Status in document $userID in collection Users has been updated to $status');
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
        users[i].status = !users[i].status;
        return users[i].status;
      }
    }
    throw Exception('couldn\'nt found the id');
  }

  bool getStatus(String id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i].status;
      }
    }
    throw Exception('could\'nt found the id');
  }
}
