// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User with ChangeNotifier {
  User({required this.id, required this.username, required this.balance, required this.gender, required this.status, required this.email, required this.phone, required this.register_date});
  final String id;
  final String username;
  final double balance;
  final String email;
  final String phone;
  final DateTime register_date;
  final int gender;
  bool status;
  String formatDate() {
    final dateNow = DateTime.now();
    final difference = dateNow.difference(register_date);
    if (difference.inDays >= 1) {
      return '${difference.inDays} Days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} Hours ago';
    }
    return '${difference.inMinutes} Minutes ago';
  }
}
