import 'package:flutter/material.dart';

class RightBubblePainter extends CustomPainter {
  final Color color;

  RightBubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final Path path = Path()
      ..moveTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0)
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 10)
      ..lineTo(size.width, size.height - 20)
      ..quadraticBezierTo(
          size.width, size.height - 10, size.width - 10, size.height - 10)
      ..lineTo(size.width - 10, size.height)
      ..lineTo(size.width - 30, size.height - 10)
      ..lineTo(10, size.height - 10)
      ..quadraticBezierTo(0, size.height - 10, 0, size.height - 20)
      ..lineTo(0, 10)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
