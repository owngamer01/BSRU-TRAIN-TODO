import 'package:flutter/material.dart';

class PercentPath extends CustomPainter {
  
  final List<Color> colors;
  final int max, min;

  PercentPath({
    @required this.max,
    @required this.min,
    @required this.colors
  });

  @override
  void paint(Canvas canvas, Size size) {
    var frontPaint = Paint()
      ..strokeWidth = 5
      ..strokeCap  = StrokeCap.round
      ..color = colors[0];

    var backPaint  = Paint()
      ..strokeWidth = 5
      ..strokeCap  = StrokeCap.round
      ..color = colors[1];

    final _min = (this.min >= this.max) ? this.max : this.min;
    final percent = (_min / this.max) * size.width;

    canvas.drawLine(
      Offset(0 , size.height / 2),
      Offset(size.width, size.height / 2),
      backPaint
    );
    if (percent > 0) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(percent, size.height / 2),
        frontPaint
      );
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}