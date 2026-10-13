import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:toktik/presentation/widgets/glass/liquid_glass.dart';

/// Barra de navegación superior con efecto de cristal flotante para TokTik.
class LiquidGlassTabBar extends StatefulWidget {
  const LiquidGlassTabBar({
    super.key,
    required this.labels,
    required this.controller,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> labels;
  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  State<LiquidGlassTabBar> createState() => _LiquidGlassTabBarState();
}

class _LiquidGlassTabBarState extends State<LiquidGlassTabBar>
    with SingleTickerProviderStateMixin {
  static const double _tabWidth = 86;
  static const double _height = 44;
  static const double _inset = 4;

  late final AnimationController _pulse = AnimationController.unbounded(vsync: this);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  double get _page {
    final controller = widget.controller;
    if (controller.hasClients && controller.position.hasContentDimensions) {
      return controller.page ?? widget.selectedIndex.toDouble();
    }
    return widget.selectedIndex.toDouble();
  }

  void _handleTap(int index) {
    _pulse.animateWith(SpringSimulation(kLiquidSpring, _pulse.value, 0, 12));
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      borderRadius: BorderRadius.circular(_height / 2),
      tintOpacity: 0.16,
      tintColor: const Color(0xFF1E1F30),
      child: SizedBox(
        width: _tabWidth * widget.labels.length + _inset * 2,
        height: _height,
        child: AnimatedBuilder(
          animation: Listenable.merge([widget.controller, _pulse]),
          builder: (context, _) {
            final page = _page;
            return Stack(
              children: [
                _buildDroplet(page),
                Positioned.fill(
                  left: _inset,
                  right: _inset,
                  child: Row(
                    children: [
                      for (int i = 0; i < widget.labels.length; i++)
                        _TabLabel(
                          label: widget.labels[i],
                          width: _tabWidth,
                          emphasis: (1 - (page - i).abs()).clamp(0.0, 1.0),
                          onTap: () => _handleTap(i),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDroplet(double page) {
    final stretch = math.sin((page - page.floorToDouble()) * math.pi).abs();
    final pulse = _pulse.value;

    return Positioned(
      left: _inset + page * _tabWidth,
      top: _inset,
      width: _tabWidth,
      height: _height - _inset * 2,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          1 + 0.22 * stretch + 0.16 * pulse,
          1 - 0.10 * stretch + 0.16 * pulse,
          1,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF00F2FE).withValues(alpha: 0.40),
                const Color(0xFF4FACFE).withValues(alpha: 0.25),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F2FE).withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.width,
    required this.emphasis,
    required this.onTap,
  });

  final String label;
  final double width;
  final double emphasis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(
                Colors.white.withValues(alpha: 0.6),
                Colors.white,
                emphasis,
              ),
              fontSize: 13.5,
              fontWeight: emphasis > 0.5 ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: -0.2,
              shadows: emphasis > 0.5
                  ? [
                      Shadow(
                        color: const Color(0xFF00F2FE).withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
