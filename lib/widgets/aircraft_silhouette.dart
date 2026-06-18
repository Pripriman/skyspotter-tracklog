import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';

class AircraftSilhouette extends StatelessWidget {
  final double size;
  final Color color;
  final double heading;

  const AircraftSilhouette({
    super.key,
    this.size = 48,
    this.color = SkyPalette.skyDeep,
    this.heading = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: heading * math.pi / 180,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _PlanePainter(color)),
      ),
    );
  }
}

class _PlanePainter extends CustomPainter {
  final Color color;
  _PlanePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(w * 0.5, h * 0.04);
    path.cubicTo(w * 0.56, h * 0.10, w * 0.56, h * 0.24, w * 0.55, h * 0.40);
    path.lineTo(w * 0.96, h * 0.62);
    path.lineTo(w * 0.96, h * 0.72);
    path.lineTo(w * 0.55, h * 0.60);
    path.lineTo(w * 0.55, h * 0.82);
    path.lineTo(w * 0.70, h * 0.92);
    path.lineTo(w * 0.70, h * 0.98);
    path.lineTo(w * 0.50, h * 0.90);
    path.lineTo(w * 0.30, h * 0.98);
    path.lineTo(w * 0.30, h * 0.92);
    path.lineTo(w * 0.45, h * 0.82);
    path.lineTo(w * 0.45, h * 0.60);
    path.lineTo(w * 0.04, h * 0.72);
    path.lineTo(w * 0.04, h * 0.62);
    path.lineTo(w * 0.45, h * 0.40);
    path.cubicTo(w * 0.44, h * 0.24, w * 0.44, h * 0.10, w * 0.5, h * 0.04);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PlanePainter old) => old.color != color;
}
