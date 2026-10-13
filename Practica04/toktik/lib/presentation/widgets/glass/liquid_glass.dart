import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const SpringDescription kLiquidSpring = SpringDescription(
  mass: 1,
  stiffness: 380,
  damping: 16,
);

/// Superficie "Liquid Glass" moderna para TokTik.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 16,
    this.tintColor = Colors.white,
    this.tintOpacity = 0.14,
    this.highlight = 0,
    this.padding,
    this.showShadow = true,
  });

  final Widget? child;
  final BorderRadius borderRadius;
  final double blur;
  final Color tintColor;
  final double tintOpacity;
  final double highlight;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;

  static const List<double> _saturationMatrix = [
    1.6, -0.5, -0.05, 0, 8,
    -0.15, 1.25, -0.05, 0, 8,
    -0.15, -0.5, 1.7, 0, 8,
    0, 0, 0, 1, 0,
  ];

  static final Map<double, ui.ImageFilter> _filterCache = {};

  static ui.ImageFilter _filterFor(double sigma) {
    return _filterCache.putIfAbsent(
      sigma,
      () => ui.ImageFilter.compose(
        outer: const ui.ColorFilter.matrix(_saturationMatrix),
        inner: ui.ImageFilter.blur(
          sigmaX: sigma,
          sigmaY: sigma,
          tileMode: ui.TileMode.mirror,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = CustomPaint(
      painter: _GlassFillPainter(
        borderRadius: borderRadius,
        color: tintColor,
        opacity: tintOpacity,
        highlight: highlight,
      ),
      foregroundPainter: _GlassRimPainter(
        borderRadius: borderRadius,
        highlight: highlight,
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );

    if (blur > 0) {
      content = BackdropFilter.grouped(filter: _filterFor(blur), child: content);
    }

    content = ClipRRect(borderRadius: borderRadius, child: content);

    if (!showShadow) return content;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: content,
    );
  }
}

Color _white(double alpha) =>
    Colors.white.withValues(alpha: alpha.clamp(0.0, 1.0));

class _GlassFillPainter extends CustomPainter {
  const _GlassFillPainter({
    required this.borderRadius,
    required this.color,
    required this.opacity,
    required this.highlight,
  });

  final BorderRadius borderRadius;
  final Color color;
  final double opacity;
  final double highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: (opacity * 1.5 + 0.12 * highlight).clamp(0.0, 1.0)),
          color.withValues(alpha: (opacity * 0.5 + 0.04 * highlight).clamp(0.0, 1.0)),
        ],
      ).createShader(rect);

    canvas.drawRRect(borderRadius.toRRect(rect), paint);
  }

  @override
  bool shouldRepaint(_GlassFillPainter old) =>
      old.color != color ||
      old.opacity != opacity ||
      old.highlight != highlight ||
      old.borderRadius != borderRadius;
}

class _GlassRimPainter extends CustomPainter {
  const _GlassRimPainter({required this.borderRadius, required this.highlight});

  final BorderRadius borderRadius;
  final double highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);
    final boost = 1 + highlight;

    canvas.save();
    canvas.clipRRect(rrect);

    final specular = Rect.fromLTWH(
      -size.width * 0.1,
      -size.height * 0.45,
      size.width * 1.2,
      size.height,
    );
    canvas.drawOval(
      specular,
      Paint()
        ..shader = RadialGradient(
          colors: [_white(0.22 * boost), _white(0)],
        ).createShader(specular),
    );

    canvas.drawRRect(
      rrect.deflate(1.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_white(0.35 * boost), _white(0), _white(0.16 * boost)],
          stops: const [0, 0.5, 1],
        ).createShader(rect),
    );
    canvas.restore();

    canvas.drawRRect(
      rrect.deflate(0.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _white(0.85 * boost),
            _white(0.15),
            _white(0.06),
            _white(0.50 * boost),
          ],
          stops: const [0, 0.4, 0.6, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlassRimPainter old) =>
      old.highlight != highlight || old.borderRadius != borderRadius;
}
