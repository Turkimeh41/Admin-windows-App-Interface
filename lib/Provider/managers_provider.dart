// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:chalkdart/chalk.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Model/manager_model.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world/Exception/exceptions.dart' as exe;

class Managers with ChangeNotifier {
  String adminIDToken = '';
  String adminDocID = '';
  List<Manager> _managers = [];

  int get managersLength {
    return _managers.length;
  }

  Future<void> fetchManagers() async {
    List<Manager> loadedManagers = [];
    final managersURL = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Managers');
    final enabledURL = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Manager_Enabled');
    final futures = await Future.wait([
      http.get(managersURL, headers: {'Authorization': 'Bearer $adminIDToken'}),
      http.get(enabledURL, headers: {'Authorization': 'Bearer $adminIDToken'})
    ]);
    final managersResponse = futures[0];
    final enabledResponse = futures[1];
    if (managersResponse.statusCode != 200) {
      throw Exception('Failed to read document');
    }
    if ((json.decode(managersResponse.body))['documents'] == null) {
      log(chalk.red.bold('No managers are created in the app!.'));
      return;
    }
    log(chalk.green.bold('Storing managers...'));
    final managerData = (json.decode(managersResponse.body))['documents'] as List<dynamic>;
    final enabledData = (json.decode(enabledResponse.body))['documents'] as List<dynamic>;
    for (int i = 0; i < managerData.length; i++) {
      final managerDocument = managerData[i]['fields'] as Map<String, dynamic>;
      final enabledDocument = enabledData[i]['fields'] as Map<String, dynamic>;
      final id = (managerData[i]['name'] as String).split('/').last;
      final username = (managerDocument['username'] as Map<String, dynamic>).values.first as String;
      final first_name = (managerDocument['first_name'] as Map<String, dynamic>).values.first as String;
      final last_name = (managerDocument['last_name'] as Map<String, dynamic>).values.first as String;
      final phone = (managerDocument['phone'] as Map<String, dynamic>).values.first as String;
      final imgURL = (managerDocument['imgURL'] as Map<String, dynamic>).values.first;
      final email_address = (managerDocument['email'] as Map<String, dynamic>).values.first as String;
      final enabled = (enabledDocument['enabled'] as Map<String, dynamic>).values.first;
      final timestamp = managerDocument["added"]['timestampValue'];
      final added = DateTime.parse(timestamp);
      loadedManagers.add(Manager(id: id, username: username, first_name: first_name, enabled: enabled, last_name: last_name, email_address: email_address, phone: phone, imgURL: imgURL, added: added));
    }

    log(chalk.blueBright.bold('Managers should be stored!'));
    _managers = loadedManagers;
  }

  Future<void> addManager(String username, String first_name, String last_name, String email, String phone, String password, String? imgURL) async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/addManager');
    log(imgURL!);
    final body = json.encode({"username": username, "first_name": first_name, "last_name": last_name, "email": email, "phone": phone, "password": password, "imgURL": imgURL});
    final response = await http.post(url, body: body, headers: {'Authorization': 'Bearer $adminIDToken'});
    if (response.statusCode != 200) {
      throw exe.UnknownException('INTERNAL', 'Internal server Error');
    }
    final Map<String, dynamic> result = jsonDecode(response.body);

    _managers.add(Manager(
        id: result['id'], username: username, enabled: true, first_name: first_name, last_name: last_name, email_address: email, phone: phone, imgURL: result["imgURL"], added: DateTime.now()));
    notifyListeners();
  }

  void adminUpdate(String idToken, String docID) {
    log('Updating admin data for managers..');
    adminIDToken = idToken;
    adminDocID = docID;
  }

  List<Manager> filteredManager(String search, int filter) {
    List<Manager> filteredManagers = [];
    switch (filter) {
      //search by id
      case 0:
        filteredManagers = _managers.where((manager) => manager.id.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
      //search by first name
      case 1:
        filteredManagers = _managers.where((manager) => manager.first_name.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
      //search by email
      case 2:
        filteredManagers = _managers.where((manager) => manager.email_address.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
      case 3:
        //search by phone
        filteredManagers = _managers.where((manager) => _removeNumberWhitespace(manager.phone).startsWith(search)).toList();
        break;
    }
    return filteredManagers;
  }

  String _removeNumberWhitespace(String phone) {
    RegExp regex = RegExp(r'\s+');
    final phone_noWhitespace = phone.replaceAll(regex, '');

    return phone_noWhitespace;
  }

  Future<void> removeManager(String managerID) async {
    final url1 = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Managers/$managerID');
    //search for user store the object reference in user to check if a user has an image to remove

    final response = await http.delete(url1, headers: {"Authorization": "Bearer $adminIDToken"});

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      log('Error failed removal of  manager , please recheck the firebase function logs and database for more details., \n error: ${error.toString()}');
      return;
    }
    for (int i = 0; i < _managers.length; i++) {
      if (_managers[i].id == managerID) {
        _managers.removeAt(i);
        break;
      }
    }

    notifyListeners();
  }

  Future<void> switchManagerStatus(String managerID) async {
    late bool enabled;
    for (int i = 0; i < _managers.length; i++) {
      if (managerID == _managers[i].id) {
        _managers[i].enabled = !_managers[i].enabled;
        enabled = _managers[i].enabled;
        break;
      }
    }
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Manager_Enabled/$managerID',
        {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng', 'updateMask.fieldPaths': 'enabled'});
    final body = jsonEncode(<String, dynamic>{
      'fields': {
        'enabled': {
          'booleanValue': enabled,
        },
      },
    });
    try {
      final response = await http.patch(url, body: body, headers: {"Authorization": "Bearer $adminIDToken"});
      if (response.statusCode == 200) {
        print('Field Status in document $managerID in collection Activites has been updated to $enabled');
      } else {
        print('Error occurred while updating field. Status code: ${response.statusCode}');
      }
    } catch (error) {
      log(error.toString());
    }

    notifyListeners();
  }
}
