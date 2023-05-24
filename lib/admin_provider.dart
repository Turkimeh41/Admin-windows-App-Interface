// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Exception/exceptions.dart' as exe;
import 'dart:convert';
import 'Handler/login_handler.dart';

class Admin with ChangeNotifier {
  String idToken = '';
  String refreshToken = '';
  String docID = '';
  int expire = 0;
  DateTime? last_login;

  void printInfo() {
    log('id-token -->$idToken');
    log('\n\n');
    log('refresh-token -->$refreshToken');
    log('\n\n');
    log('doc-ID -->$docID');
    log('\n\n');
    log('expires in -->$expire');
  }

  void clear() {
    idToken = '';
    refreshToken = '';
    docID = '';
    expire = 0;
    log('admin cleared');
    notifyListeners();
  }

  String formatDate() {
    final dateNow = DateTime.now();
    final difference = dateNow.difference(last_login!);
    if (difference.inDays >= 1) {
      return '${difference.inDays} Days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} Hours ago';
    }
    return '${difference.inMinutes} Minutes ago';
  }

  Future<String> adminLogin() async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/adminLogin');
    final response = await http.post(url, body: {'username': LoginHandler.userController.text, 'password': LoginHandler.passController.text});
    if (response.statusCode == 400) {
      throw exe.InvalidArgumentException('invalid', 'invalid username or password.');
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String customToken = data['customToken'];
    docID = data['adminID'];

    return customToken;
  }

  Future<void> setANDgetTIME() async {
    final url = Uri.https('europe-west1-final497.cloudfunctions.net', '/setgetTime');
    final response = await http.get(url);
    if (response.statusCode == 400) {
      throw exe.InvalidArgumentException('invalid', 'invalid username or password.');
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    final timestamp = data['last_login'];
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp['_seconds']! * 1000 + (timestamp['_nanoseconds']! / 1000000).round());
    last_login = dateTime;
  }

  Future<void> signInWithCustomToken(String customToken) async {
    final url = Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:signInWithCustomToken', {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng'});
    final response = await http.post(url, body: {'token': customToken, 'returnSecureToken': 'true'});
    final Map<String, dynamic> data = jsonDecode(response.body);

    idToken = data['idToken'];
    refreshToken = data['refreshToken'];
    expire = int.parse(data['expiresIn']);

    notifyListeners();
    log('admin data has been set...updating Changenotifier should be now invoked');
  }

  Future<void> refreshNewToken() async {
    log('getting new tokens...');
    final url = Uri.https('securetoken.googleapis.com', '/v1/token', {'key': 'AIzaSyAq28V6zXnjwY00dgh0ifw8WCPJfVikqng'});
    final response = await http.post(url, body: {'refresh_token': refreshToken, 'grant_type': 'refresh_token'});
    final Map<String, dynamic> data = jsonDecode(response.body);
    idToken = data['id_token'];
    refreshToken = data['refresh_token'];
    expire = int.parse(data['expires_in']);
    log('recieved and set');
    Timer(const Duration(hours: 1), () async {
      refreshNewToken();
    });
    notifyListeners();
  }
}
