import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:toktik/presentation/widgets/glass/liquid_glass.dart';

/// Botón circular de vidrio líquido con micro-interacción reactiva.
class LiquidGlassButton extends StatefulWidget {
  const LiquidGlassButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 52,
    this.tint,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double size;
  final Color? tint;

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController.unbounded(vsync: this);

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _springTo(double target, {double velocity = 0}) {
    _press.animateWith(
      SpringSimulation(kLiquidSpring, _press.value, target, velocity),
    );
  }

  void _onPressDown() => _springTo(1, velocity: _press.velocity);

  void _onPressUp() => _springTo(0, velocity: math.max(_press.velocity, 10));

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.size / 2);

    return GestureDetector(
      onTapDown: (_) => _onPressDown(),
      onTapUp: (_) => _onPressUp(),
      onTapCancel: () => _springTo(0),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _press,
        child: SizedBox.square(
          dimension: widget.size,
          child: Center(child: widget.child),
        ),
        builder: (context, child) {
          final value = _press.value;
          return Transform.scale(
            scale: 1 + 0.14 * value,
            child: LiquidGlass(
              borderRadius: radius,
              highlight: value.clamp(0.0, 1.5),
              tintColor: widget.tint ?? Colors.white,
              tintOpacity: widget.tint == null ? 0.14 : 0.25,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
