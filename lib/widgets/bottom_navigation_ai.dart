import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:handsingdetection/theme/app_theme.dart';

class BottomNavigationAI extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationAI({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final navItems = [
      {'icon': Icons.home_rounded,     'label': 'Home'},
      {'icon': Icons.settings_rounded, 'label': 'Settings'},
    ];

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft:  Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: c.navBg,
              borderRadius: const BorderRadius.only(
                topLeft:  Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(color: c.navBorder, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: c.isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isActive = currentIndex == index;

                return GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 24),
                    decoration: isActive
                        ? BoxDecoration(
                      color: c.accentSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: c.accent.withOpacity(0.4),
                          width: 1),
                    )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          navItems[index]['icon'] as IconData,
                          size: 22,
                          color: isActive ? c.accent : c.textMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          navItems[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isActive ? c.accent : c.textMuted,
                          ),
                        ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 4, height: 4,
                            decoration: BoxDecoration(
                              color: c.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}