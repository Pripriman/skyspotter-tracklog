import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';
import '../theme/sky_type.dart';

class LiftButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool expand;
  final IconData? icon;

  const LiftButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.expand = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final btn = AnimatedOpacity(
      opacity: enabled ? 1 : 0.6,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onPressed : null,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SkyPalette.sky, SkyPalette.skyDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: SkyPalette.skyDeep.withValues(alpha: 0.32),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              height: 54,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Text(label,
                            style: SkyType.heading(color: Colors.white)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class GhostLink extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GhostLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: SkyPalette.skyDeep,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(label, style: SkyType.label(color: SkyPalette.skyDeep)),
        ],
      ),
    );
  }
}
