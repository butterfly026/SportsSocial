import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double radius;
  final Color color;

  CirclePainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Use the provided color
      ..style = PaintingStyle.fill; // Set the style to fill the circle

    // Draw the circle at the center of the canvas
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius, // Use the provided radius
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}