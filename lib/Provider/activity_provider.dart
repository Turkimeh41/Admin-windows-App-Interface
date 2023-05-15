// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Activity with ChangeNotifier {
  String id;
  String name;
  double price;
  String type;
  int duration;
  final DateTime created_date;
  String img_link;
  final int multiplier;
  int played;
  bool enabled;

  Activity(
      {required this.id,
      required this.name,
      required this.price,
      required this.type,
      required this.duration,
      required this.created_date,
      required this.img_link,
      required this.multiplier,
      required this.played,
      required this.enabled});
}
