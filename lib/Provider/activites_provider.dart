// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:chalkdart/chalk.dart';
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
      log(chalk.yellow.bold("======================================================="));
      final document = data[i]['fields'] as Map<String, dynamic>;
      final id = (data[i]['name'] as String).split('/').last;
      log(chalk.green.bold("${'id Value: $id'}, Type: ${id.runtimeType.toString()} "));
      final name = document['name']['stringValue'] as String;
      late final pricePlaceHolder = (document["price"] as Map<String, dynamic>).values.first;
      log(chalk.green.bold("${'price Value: $pricePlaceHolder'}, Type: ${pricePlaceHolder.runtimeType.toString()} "));
      late final durationPlaceHolder = (document["duration"] as Map<String, dynamic>).values.first;
      log(chalk.green.bold("${'duration Value: $durationPlaceHolder'}, Type: ${durationPlaceHolder.runtimeType.toString()} "));
      late final playedPlaceHolder = (document["played"] as Map<String, dynamic>).values.first;
      log(chalk.green.bold("${'played Value: $playedPlaceHolder'}, Type: ${playedPlaceHolder.runtimeType.toString()} "));
      late final multiplierPlaceHolder = (document["multiplier"] as Map<String, dynamic>).values.first;
      log(chalk.green.bold("${'multiplier Value: $multiplierPlaceHolder'}, Type: ${multiplierPlaceHolder.runtimeType.toString()} "));
      late final enabledPlaceHolder = (document["enabled"] as Map<String, dynamic>).values.first;
      log(chalk.green.bold("${'enabled Value: $enabledPlaceHolder'}, Type: ${enabledPlaceHolder.runtimeType.toString()} "));

      final String type = document['type']['stringValue'];
      late String imglink = document["img_link"]["stringValue"];
      final timestamp = document["createdAt"]['timestampValue'];
      late final double price;
      if (pricePlaceHolder is double) {
        price = pricePlaceHolder;
      } else if (pricePlaceHolder is String) {
        price = double.parse(pricePlaceHolder);
      }
      final int duration = int.parse(durationPlaceHolder);
      final int played = int.parse(playedPlaceHolder);
      final int multiplier = int.parse(multiplierPlaceHolder);
      final bool enabled = enabledPlaceHolder;

      final createdAt = DateTime.parse(timestamp);

      loadedActivites
          .add(Activity(id: id, img_link: imglink, name: name, price: price, type: type, duration: duration, created_date: createdAt, played: played, multiplier: multiplier, enabled: enabled));
      log(chalk.yellow.bold("========================================================================="));
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
    _activites
        .add(Activity(id: data['id'], name: name, price: price, type: type, duration: duration, created_date: DateTime.now(), img_link: data['img_link'], enabled: true, multiplier: 1, played: 0));
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

  Future<void> editActivity({required String id, required String name, required String type, required int duration, required double price, required Uint8List? img}) async {
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
    _activites[i].img_link = data['imgURL'];

    notifyListeners();
  }

  void adminUpdate(String idToken, String docID) {
    log('updating admin data for activites');
    this.idToken = idToken;
    this.docID = docID;
  }
}
