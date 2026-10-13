import 'package:flutter/material.dart';

/// Barra de navegación superior moderna y minimalista para TokTik.
class ModernTopNavBar extends StatelessWidget {
  final List<String> labels;
  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ModernTopNavBar({
    super.key,
    required this.labels,
    required this.controller,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.65),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye uniformemente el espacio sin desbordar
        children: [
          for (int i = 0; i < labels.length; i++)
            _NavItem(
              label: labels[i],
              isSelected: selectedIndex == i,
              onTap: () => onTabSelected(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        // Reducimos el padding horizontal para que quepan perfectamente en cualquier pantalla
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.55),
                fontSize: isSelected ? 15 : 13.5, // Ligeramente ajustado para ganar espacio
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: -0.3,
                shadows: isSelected
                    ? [
                        Shadow(
                          color: const Color(0xFFFF3366).withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            // Línea indicadora inferior animada
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 3,
              width: isSelected ? 20 : 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3366), Color(0xFF00E5FF)],
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF3366).withValues(alpha: 0.8),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}