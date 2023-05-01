import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/Provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final insActivity = Provider.of<Activity>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(insActivity.img_link),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
