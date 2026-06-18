import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';

class StatDial extends StatelessWidget {
  final double size;
  final double progress;
  final Color color;
  final Color track;
  final double stroke;
  final Widget? child;

  const StatDial({
    super.key,
    required this.size,
    required this.progress,
    this.color = SkyPalette.sky,
    this.track = SkyPalette.skyWash,
    this.stroke = 12,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DialPainter(
          progress: progress.clamp(0, 1).toDouble(),
          color: color,
          track: track,
          stroke: stroke,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;
  final double stroke;

  _DialPainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [SkyPalette.sky, SkyPalette.skyDeep],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke;
}
