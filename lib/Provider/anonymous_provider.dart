import 'dart:convert';
import 'dart:developer';

import 'package:chalkdart/chalk.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Model/anonymous_user_model.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world/Exception/exceptions.dart' as exe;

class AnonymousUsers with ChangeNotifier {
  String adminIDToken = '';
  String adminDocID = '';

  List<AnonymousUser> _anonymousUsers = [];

  List<AnonymousUser> get anonymousUsers {
    return [..._anonymousUsers];
  }

  Future<void> fetchAnonymousUsers() async {
    List<AnonymousUser> loadedAnonyUsers = [];
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Anonymous_Users');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $adminIDToken'});
    if (response.statusCode != 200) {
      throw Exception('Failed to read document');
    }
    if ((json.decode(response.body))['documents'] == null) {
      log(chalk.red.bold('No anonymous data'));
      return;
    }
    log(chalk.white.bold("================================================================="));
    log('Storing Anonymous Users...');
    final data = (json.decode(response.body))['documents'] as List<dynamic>;

    log("We have ${data.length} of Anonymous users that we will add");
    for (int i = 0; i < data.length; i++) {
      log(chalk.yellow.bold("======================================================="));
      final document = data[i]['fields'] as Map<String, dynamic>;
      final anonymousID = (data[i]['name'] as String).split('/').last;
      log(anonymousID);
      final providerAccountID = (document['providerAccountID'] as Map<String, dynamic>).values.first as String;
      log(providerAccountID);
      final label = (document["label"] as Map<String, dynamic>).values.first as String;
      log(label);
      final qrURL = (document["qr_link"] as Map<String, dynamic>).values.first as String;
      log(qrURL);
      final date = (document["assignedDate"] as Map<String, dynamic>).values.first;
      log(label);
      log(chalk.green.bold("${'date Value: $date'}, Type: ${date.runtimeType.toString()} "));
      final balancePlaceHolder = (document["balance"] as Map<String, dynamic>).values.first;
      late double balance;
      if (balancePlaceHolder is String) {
        balance = double.parse(balancePlaceHolder);
      } else if (balancePlaceHolder is double) {
        balance = balancePlaceHolder;
      } else {
        balance = (balancePlaceHolder as int).toDouble();
      }
      loadedAnonyUsers.add(AnonymousUser(id: anonymousID, qrURL: qrURL, providerAccountID: providerAccountID, balance: balance, label: label, assignedDate: date));
      log(chalk.yellow.bold("======================================================="));
    }
    _anonymousUsers = loadedAnonyUsers;
  }

  Future<void> removeAnonymous(String anonyID) async {
    final url1 = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Anonymous_Users/$anonyID');
    //search for user store the object reference in user to check if a user has an image to remove

    final response = await http.delete(url1, headers: {"Authorization": "Bearer $adminIDToken"});

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      log('Error failed removal of  , please recheck the firebase function logs and database for more details., \n error: ${error.toString()}');
      return;
    }
    for (int i = 0; i < _anonymousUsers.length; i++) {
      if (_anonymousUsers[i].id == anonyID) {
        _anonymousUsers.removeAt(i);
        break;
      }
    }

    notifyListeners();
  }

  Future<void> generateAnonymous() async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/generateAnonyQR');
    final response = await http.post(url, headers: {'Authorization': 'Bearer $adminIDToken'});
    if (response.statusCode != 200) {
      throw exe.UnknownException('INTERNAL', 'Internal server Error');
    }
    final Map<String, dynamic> result = jsonDecode(response.body);

    _anonymousUsers.add(AnonymousUser(id: result['anonyID'], qrURL: result['qrURL'], providerAccountID: 'null', balance: 0.0, label: 'null', assignedDate: null));
    notifyListeners();
  }

  List<AnonymousUser> filteredAnonymous(String search, int filter) {
    List<AnonymousUser> filteredAnonymous = [];
    switch (filter) {
      //search by id
      case 0:
        filteredAnonymous = _anonymousUsers.where((manager) => manager.id.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
      //search by  providerID
      case 1:
        filteredAnonymous = _anonymousUsers.where((manager) => manager.providerAccountID.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
      //search by label
      case 2:
        filteredAnonymous = _anonymousUsers.where((manager) => manager.label.toLowerCase().startsWith(search.toLowerCase())).toList();
        break;
    }
    return filteredAnonymous;
  }

  void adminUpdate(String adminIDToken, String adminDocID) {
    this.adminIDToken = adminIDToken;
    this.adminDocID = adminDocID;
  }
}
