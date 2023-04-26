// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

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
      final duration = int.parse(document['duration']['integerValue']);
      final timestamp = document['createdAt']['timestampValue'];
      final createdAt = DateTime.parse(timestamp);
      loadedActivites.add(Activity(id: id, name: name, price: price, type: type, duration: duration, created_date: createdAt));
    }

    print('Activites should be stored!');
    _activites = loadedActivites;
  }

  void adminUpdate(String idToken, String docID) {
    log('updating admin data for activites');
    this.idToken = idToken;
    this.docID = docID;
  }
}
