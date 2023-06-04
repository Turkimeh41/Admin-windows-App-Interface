// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:chalkdart/chalk.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import '../Model/activity_model.dart';
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
      log(chalk.red.bold('Theres no Activites currently in the app!'));
      return;
    }
    log(chalk.green.bold('Storing activites...'));
    final data = (json.decode(response.body))['documents'] as List<dynamic>;
    log("we have ${data.length} of activites that we will add");
    for (int i = 0; i < data.length; i++) {
      final document = data[i]['fields'] as Map<String, dynamic>;
      final id = (data[i]['name'] as String).split('/').last;
      final name = (document['name'] as Map<String, dynamic>).values.first;
      late final pricePlaceHolder = (document["price"] as Map<String, dynamic>).values.first;
      int duration = int.parse((document["duration"] as Map<String, dynamic>).values.first);
      final int played = int.parse((document["played"] as Map<String, dynamic>).values.first);
      final int multiplier = int.parse((document["multiplier"] as Map<String, dynamic>).values.first);
      final bool enabled = (document["enabled"] as Map<String, dynamic>).values.first;
      final String type = (document["type"] as Map<String, dynamic>).values.first;
      String imgURL = (document["imgURL"] as Map<String, dynamic>).values.first;
      int seats = int.parse((document["seats"] as Map<String, dynamic>).values.first);
      final timestamp = (document["createdAt"] as Map<String, dynamic>).values.first;

      late final double price;
      if (pricePlaceHolder is double) {
        price = pricePlaceHolder;
      } else if (pricePlaceHolder is String) {
        price = double.parse(pricePlaceHolder);
      }

      final createdAt = DateTime.parse(timestamp);

      loadedActivites.add(Activity(
        id: id,
        imgURL: imgURL,
        name: name,
        price: price,
        type: type,
        duration: duration,
        created_date: createdAt,
        played: played,
        multiplier: multiplier,
        enabled: enabled,
        seats: seats,
      ));
    }

    log(chalk.blueBright.bold('Activites should be stored!'));
    _activites = loadedActivites;
  }

  Future<void> addActivity({required String name, required String type, required int seats, required int duration, required double price, required XFile image_file}) async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/addActivity');
    final file_bytes = await image_file.readAsBytes();
    final base64Image = base64Encode(file_bytes);
    final String body = json.encode({"name": name, "type": type, "duration": duration, "price": price, "image_bytes": base64Image});
    final response = await http.post(url, body: body, headers: {'Authorization': 'Bearer $idToken'});

    if (response.statusCode != 200) {
      return;
    }
    final data = jsonDecode(response.body);
    _activites.add(Activity(
        id: data['id'], name: name, price: price, type: type, duration: duration, created_date: DateTime.now(), imgURL: data['imgURL'], enabled: true, multiplier: 1, played: 0, seats: seats));
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

  Future<void> editActivity({required String id, required String name, required String type, required int seats, required int duration, required double price, required Uint8List? img}) async {
    late final String base64FormatStringImg;
    //we did this to send the sString json format since base64 can be decoded as a list of bytes that can be used to create the image buffer
    if (img != null) {
      base64FormatStringImg = base64Encode(img);
    } else {
      base64FormatStringImg = "null";
    }

    late int i;
    for (int index = 0; index < _activites.length; index++) {
      if (_activites[index].id == id) {
        i = index;
        _activites[index].name = name;
        _activites[index].type = type;
        _activites[index].duration = duration;
        _activites[index].price = price;
      }
    }
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/editActivity');
    final payload = json.encode({"id": id, "name": name, "type": type, "duration": duration, "price": price, "base64Image": base64FormatStringImg});

    final response = await http.post(url, body: payload, headers: {'Authorization': 'Bearer $idToken'});
    if (img == null) {
      notifyListeners();
      return;
    }
    final data = json.decode(response.body);
    _activites[i].imgURL = data['imgURL'];

    notifyListeners();
  }

  Future<void> switchActivity(String activityID) async {
    late bool enabled;
    for (int i = 0; i < _activites.length; i++) {
      if (activityID == _activites[i].id) {
        _activites[i].enabled = !_activites[i].enabled;
        enabled = _activites[i].enabled;
        break;
      }
    }
    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Activites/$activityID',
        {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng', 'updateMask.fieldPaths': 'enabled'});
    final body = jsonEncode(<String, dynamic>{
      'fields': {
        'enabled': {
          'booleanValue': enabled,
        },
      },
    });
    try {
      final response = await http.patch(url, body: body, headers: {"Authorization": "Bearer $idToken"});
      if (response.statusCode == 200) {
        print('Field Status in document $activityID in collection Activites has been updated to $enabled');
      } else {
        print('Error occurred while updating field. Status code: ${response.statusCode}');
      }
    } catch (error) {
      log(error.toString());
    }

    notifyListeners();
  }

  Future<void> deleteActivity(String activityID) async {
    for (int i = 0; i < _activites.length; i++) {
      if (activityID == _activites[i].id) {
        _activites.removeAt(i);
        break;
      }
    }

    final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Activites/$activityID');
    await http.delete(url, headers: {"Authorization": "Bearer $idToken"});
    notifyListeners();
  }

  void adminUpdate(String idToken, String docID) {
    log('Updating admin data for activites..');
    this.idToken = idToken;
    this.docID = docID;
  }

  Future<void> fetchCurrentUsers() async {
    log('fetching...');
    for (int i = 0; i < _activites.length; i++) {
      final url = Uri.https('firestore.googleapis.com', '/v1beta1/projects/final497/databases/(default)/documents/Activites/${_activites[i].id}/Current_Users');
      final response = await http.get(url, headers: {"Authorization": "Bearer $idToken"});
      if (response.statusCode != 200) {
        log('error');
        throw Exception('Failed to read document');
      }
      if ((json.decode(response.body))['documents'] == null) {
        log('for the activity number $i, the document is null therefore users will be 0');
        _activites[i].currentUsers = 0;
      } else {
        final data = (json.decode(response.body))['documents'] as List<dynamic>;
        log('for the activity number $i, the document size is ${data.length}, storing it...');
        _activites[i].currentUsers = data.length;
      }
    }
    notifyListeners();
  }
}
