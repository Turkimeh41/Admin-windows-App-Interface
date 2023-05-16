// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class User with ChangeNotifier {
  User(
      {required this.id,
      required this.img_link,
      required this.username,
      required this.balance,
      required this.gender,
      required this.status,
      required this.email,
      required this.phone,
      required this.register_date});
  final String id;
  final String username;
  final double balance;
  final String email;
  final String phone;
  final String img_link;
  final DateTime register_date;
  final int gender;
  bool status;
  BalanceEntry entry;
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
