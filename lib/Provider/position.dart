import 'package:flutter/material.dart';
import 'package:render_metrics/render_metrics.dart';

class Positions {
  final renderManager = RenderParametersManager<dynamic>();

  List<String> _firstIn = [];

  List<String> get firstIn {
    return [..._firstIn];
  }

  void addQueue(String id) {
    _firstIn.add(id);
  }

  void reset() {
    _firstIn = [];
  }

  String firstID() {
    return _firstIn[0];
  }
}
