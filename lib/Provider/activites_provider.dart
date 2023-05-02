// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'activity_provider.dart';
import 'package:http/http.dart' as http;

class Activites with ChangeNotifier {
  String idToken = '';
  String docID = '';

  List<Activity> _activites = [];

  List<Activity> get activites {
    return [..._activites];
  }

  Future<void> fetchActivites() async {
    List<Activity> loadedActivites = [];
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Activites');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $idToken'});
    if (response.statusCode != 200) {
      throw Exception('Failed to read document');
    }
    if ((json.decode(response.body))['documents'] == null) {
      log('no activity data');
      return;
    }
    log('Storing Activites...');
    final data = (json.decode(response.body))['documents'] as List<dynamic>;
    log("we have ${data.length} of activites that we will add");
    for (int i = 0; i < data.length; i++) {
      final document = data[i]['fields'] as Map<String, dynamic>;
      final id = (data[i]['name'] as String).split('/').last;
      final name = document['name']['stringValue'] as String;

      final priceValue = document['price'];

      double price;
      if (priceValue['integerValue'] != null) {
        price = double.parse(priceValue['integerValue']);
      } else if (priceValue['doubleValue'] != null) {
        price = priceValue['doubleValue'];
      } else {
        throw Exception('price value is not valid.');
      }

      final type = document['type']['stringValue'] as String;
      final img_link = document['img_link']['stringValue'] as String;
      final duration = int.parse(document['duration']['integerValue']);
      final timestamp = document['createdAt']['timestampValue'];
      final createdAt = DateTime.parse(timestamp);
      loadedActivites.add(Activity(id: id, img_link: img_link, name: name, price: price, type: type, duration: duration, created_date: createdAt));
    }

    print('Activites should be stored!');
    _activites = loadedActivites;
  }

  Future<void> addActivity({required String name, required String type, required int duration, required double price, required XFile image_file}) async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/addActivity');
    final file_bytes = await image_file.readAsBytes();
    final base64Image = base64Encode(file_bytes);
    final String body = json.encode({"name": name, "type": type, "duration": duration, "price": price, "image_bytes": base64Image});
    final response = await http.post(url, body: body, headers: {'Authorization': 'Bearer $idToken'});

    if (response.statusCode != 200) {
      log('test');
      final data = jsonDecode(response.body);
      log(data);
      return;
    }
    final data = jsonDecode(response.body);
    _activites.add(Activity(id: data['id'], name: name, price: price, type: type, duration: duration, created_date: DateTime.now(), img_link: data['img_link']));
    log('successful! added Activity');
    notifyListeners();
  }

  List<Activity> searchActivity({required String search, required int filter}) {
    List<Activity> filteredUsers = [];
    switch (filter) {
//id
      case 0:
        filteredUsers = _activites.where((activity) => activity.name.toLowerCase().startsWith(search)).toList();

        break;
      case 1:
        filteredUsers = _activites.where((activity) => activity.type.toLowerCase().startsWith(search)).toList();
        break;
    }

    return filteredUsers;
  }

  Future<void> editActivity({required String id}) async {}

  void adminUpdate(String idToken, String docID) {
    log('updating admin data for activites');
    this.idToken = idToken;
    this.docID = docID;
  }
}
