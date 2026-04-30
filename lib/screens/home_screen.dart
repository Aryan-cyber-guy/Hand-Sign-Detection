import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:handsingdetection/screens/camera_screen.dart';
import 'package:handsingdetection/screens/settings_screen.dart';
import 'package:handsingdetection/theme/app_theme.dart';
import 'package:handsingdetection/theme/theme_provider.dart';
import 'package:handsingdetection/widgets/bottom_navigation_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeDashboard(),
      const SettingsScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationAI(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  // ── HOME DASHBOARD ──────────────────────────────────────────────────────

  Widget _buildHomeDashboard() {
    final c = context.colors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.gradStart, c.gradMid, c.gradEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header + theme toggle ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gesture Detection",
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "AI-powered hand gesture recognition",
                          style: TextStyle(
                              color: c.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _themeToggle(c),
                ],
              ),

              const SizedBox(height: 28),

              // ── Stat cards ──
              Row(
                children: [
                  _statCard(c, "Model", "Tensor\nFlow", Icons.memory, Colors.cyan),
                  _statCard(c, "Accuracy", "92%", Icons.analytics, Colors.green),
                  _statCard(c, "FPS", "20+", Icons.speed, Colors.purple),
                ],
              ),

              const SizedBox(height: 34),

              // ── Start Detection button ──
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CameraScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        c.accentSoft,
                        c.isDark
                            ? const Color(0x338A2BE2)
                            : const Color(0x207C3AED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: c.accent.withOpacity(0.7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: c.accent.withOpacity(0.3),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: c.accent, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Start Detection",
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ── Settings feature card ──
              GestureDetector(
                onTap: () => _onNavTap(1),
                child: _featureCard(
                  c,
                  "App Settings",
                  "Configure app preferences",
                  Icons.settings_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Animated theme toggle pill ──────────────────────────────────────────

  Widget _themeToggle(AppColors c) {
    return GestureDetector(
      onTap: () => context.read<ThemeProvider>().toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 54,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: c.accentSoft,
          border: Border.all(color: c.accent.withOpacity(0.5)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment:
          c.isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.accent,
              ),
              child: Icon(
                c.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                color: c.isDark ? Colors.black : Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Widgets ─────────────────────────────────────────────────────────────

  Widget _statCard(AppColors c, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
          boxShadow: c.isDark
              ? []
              : [const BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(color: c.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ]),
      ),
    );
  }

  Widget _featureCard(
      AppColors c, String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
        boxShadow: c.isDark
            ? []
            : [const BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: c.accentSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: c.accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style:
                  TextStyle(color: c.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: c.textMuted),
      ]),
    );
  }
}