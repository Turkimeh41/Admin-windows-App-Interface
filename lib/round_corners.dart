import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class RoundWidget {
  static Widget initWindowCorner(
      {required Widget? child, required BuildContext context, required Color windowCaptionColor, Color? tabbarColor, required Brightness brightness, LinearGradient? gradient}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          /// Fake window border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child!,
            ),
          ),
          Positioned(
            right: 0,
            child: DragToMoveArea(
              child: Container(
                decoration: BoxDecoration(color: tabbarColor, gradient: gradient),
                width: MediaQuery.of(context).size.width * 1,
                height: 25,
              ),
            ),
          ),

          /// Window Caption
          Positioned(
              top: 0,
              right: 0,
              height: 25,
              width: 160,
              child: WindowCaption(
                brightness: brightness,
                backgroundColor: windowCaptionColor,
              )),

          /// Resizable Border
          const DragToResizeArea(
            enableResizeEdges: [
              ResizeEdge.topLeft,
              ResizeEdge.top,
              ResizeEdge.topRight,
              ResizeEdge.left,
              ResizeEdge.right,
              ResizeEdge.bottom,
              ResizeEdge.bottomRight,
            ],
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
