import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';

class BarcodeStrip extends StatelessWidget {
  final String seed;
  final double height;
  final Color color;

  const BarcodeStrip({
    super.key,
    required this.seed,
    this.height = 38,
    this.color = SkyPalette.ink,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _BarcodePainter(seed, color)),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  final String seed;
  final Color color;
  _BarcodePainter(this.seed, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed.hashCode);
    final paint = Paint()..color = color;
    var x = 0.0;
    while (x < size.width) {
      final barWidth = 1.0 + rng.nextInt(4);
      if (rng.nextBool()) {
        canvas.drawRect(
          Rect.fromLTWH(x, 0, barWidth, size.height),
          paint,
        );
      }
      x += barWidth + (1 + rng.nextInt(3));
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter old) =>
      old.seed != seed || old.color != color;
}

class PerforationLine extends StatelessWidget {
  final Color color;
  const PerforationLine({super.key, this.color = SkyPalette.hairline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashPainter(color)),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  _DashPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4;
    const dash = 5.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}
