// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Activity with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String type;
  final int duration;
  final DateTime created_date;

  Activity({required this.id, required this.name, required this.price, required this.type, required this.duration, required this.created_date});
}
