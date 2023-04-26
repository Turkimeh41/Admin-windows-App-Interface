import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key, required this.height, this.color, this.thickness});
  final double height;
  final Color? color;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? const Color.fromARGB(255, 71, 71, 92),
      width: thickness,
      height: height,
    );
  }
}
