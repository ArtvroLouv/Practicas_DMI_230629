import 'dart:math' as math;
import 'package:flutter/material.dart';

class HourglassLoading extends StatefulWidget {
  const HourglassLoading({super.key});

  @override
  State<HourglassLoading> createState() => _HourglassLoadingState();
}

class _HourglassLoadingState extends State<HourglassLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        double turns;
        if (t < 0.4) {
          turns = Curves.easeInOutCubic.transform(t / 0.4) * 0.5;
        } else if (t < 0.5) {
          turns = 0.5;
        } else if (t < 0.9) {
          turns = 0.5 + Curves.easeInOutCubic.transform((t - 0.5) / 0.4) * 0.5;
        } else {
          turns = 1.0;
        }

        return Transform.rotate(
          angle: turns * math.pi * 2,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF131522).withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF00F2FE).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F2FE).withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.hourglass_bottom_rounded,
          color: Color(0xFF00F2FE),
          size: 38,
        ),
      ),
    );
  }
}
