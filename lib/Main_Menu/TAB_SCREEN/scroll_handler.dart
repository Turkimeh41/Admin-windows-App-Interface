import 'package:flutter/material.dart';

class ScrollHandler {
  ScrollController controller = ScrollController();

  double _startPosition = 0.0;
  void onPanStart(DragStartDetails details) {
    _startPosition = details.globalPosition.dy;
  }

  void onPanUpdate(DragUpdateDetails details) {
    final double offset = (_startPosition - details.globalPosition.dy) / 0.35;
    final double currentOffset = controller.offset + offset;

    // Get the minimum and maximum heights
    const double minHeight = 0.0;
    final double maxHeight = controller.position.maxScrollExtent;

    // Restrict dragging up if already at minimum height
    if (currentOffset < minHeight && controller.offset <= minHeight) {
      return;
    }

    // Restrict dragging down if already at maximum height
    if (currentOffset > maxHeight && controller.offset >= maxHeight) {
      return;
    }

    // Update the offset and start position
    controller.jumpTo(currentOffset.clamp(minHeight, maxHeight));
    _startPosition = details.globalPosition.dy;
  }
}
