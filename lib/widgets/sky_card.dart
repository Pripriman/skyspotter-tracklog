import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';

class SkyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final Border? border;

  const SkyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? SkyPalette.card,
        borderRadius: BorderRadius.circular(20),
        border: border ?? Border.all(color: SkyPalette.hairline, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
