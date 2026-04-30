import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:handsingdetection/theme/app_theme.dart';
import 'package:handsingdetection/theme/theme_provider.dart';
import 'package:handsingdetection/theme/haptic_provider.dart';
import 'package:handsingdetection/screens/about_us_screen.dart';
import 'package:handsingdetection/screens/how_to_use_screen.dart';
import 'package:handsingdetection/screens/terms_screen.dart';
import 'package:handsingdetection/utils/app_content.dart';
import 'package:handsingdetection/screens/feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final themeProvider = context.watch<ThemeProvider>();
    final hapticProvider = context.watch<HapticProvider>();

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
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure app preferences',
                style: TextStyle(color: c.textSecondary),
              ),

              const SizedBox(height: 28),

              // APPEARANCE
              _sectionLabel(c, 'APPEARANCE'),
              const SizedBox(height: 10),
              _card(c, children: [
                _themeTile(c, themeProvider),
              ]),

              const SizedBox(height: 24),

              // GENERAL
              _sectionLabel(c, 'GENERAL'),
              const SizedBox(height: 10),
              _card(c, children: [
                _toggleTile(
                  c,
                  title: 'Haptic Feedback',
                  subtitle: 'Vibration on gesture detection',
                  icon: Icons.vibration,
                  color: Colors.purpleAccent,
                  value: hapticProvider.enabled,
                  onChanged: (v) {
                    hapticProvider.toggle(v);

                    if (v) {
                      HapticFeedback.mediumImpact();
                    }
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // MODEL INFO
              _sectionLabel(c, 'MODEL INFO'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      c.accent.withOpacity(0.12),
                      Colors.purpleAccent.withOpacity(0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.memory, color: c.accent, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TensorFlow + MediaPipe',
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Real-time gesture detection engine',
                            style: TextStyle(
                              color: c.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INFORMATION
              _sectionLabel(c, 'INFORMATION'),
              const SizedBox(height: 10),
              _card(c, children: [
                _navTile(
                  c,
                  icon: Icons.help_outline_rounded,
                  color: Colors.orangeAccent,
                  title: 'How to Use',
                  subtitle: 'Step-by-step usage guide',
                  onTap: () => _push(context, const HowToUseScreen()),
                ),
                _divider(c),
                _navTile(
                  c,
                  icon: Icons.info_outline_rounded,
                  color: c.accent,
                  title: 'About Us',
                  subtitle: 'App & team information',
                  onTap: () => _push(context, const AboutUsScreen()),
                ),
                _divider(c),
                _navTile(
                  c,
                  icon: Icons.gavel_rounded,
                  color: Colors.pinkAccent,
                  title: 'Terms & Conditions',
                  subtitle: 'Usage policy & privacy',
                  onTap: () => _push(context, const TermsScreen()),
                ),
                _divider(c),
                _navTile(
                  c,
                  icon: Icons.feedback_outlined,
                  color: Colors.teal,
                  title: 'Feedback',
                  subtitle: 'Share your experience',
                  onTap: () => _push(context, const FeedbackScreen()),
                ),
              ]),


              const SizedBox(height: 30),

              Center(
                child: Text(
                  '${AppContent.appName} v${AppContent.appVersion}',
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _sectionLabel(AppColors c, String text) => Text(
    text,
    style: TextStyle(
      color: c.textMuted,
      fontSize: 12,
      letterSpacing: 1.2,
    ),
  );

  Widget _card(AppColors c, {required List<Widget> children}) => Container(
    decoration: BoxDecoration(
      color: c.bgCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.border),
    ),
    child: Column(children: children),
  );

  Widget _divider(AppColors c) => Divider(color: c.border, height: 1);

  Widget _navTile(
      AppColors c, {
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) =>
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: TextStyle(
                          color: c.textMuted,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: c.textMuted),
            ],
          ),
        ),
      );

  Widget _themeTile(AppColors c, ThemeProvider provider) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Icon(
          provider.isDark ? Icons.nightlight_round : Icons.wb_sunny,
          color: provider.isDark ? Colors.indigo : Colors.orange,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            provider.isDark ? 'Dark Mode' : 'Light Mode',
            style: TextStyle(
              color: c.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: provider.isDark,
          activeColor: c.accent,
          onChanged: (_) => provider.toggleTheme(),
        ),
      ],
    ),
  );

  Widget _toggleTile(
      AppColors c, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required bool value,
        required Function(bool) onChanged,
      }) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
            Switch(
              value: value,
              activeColor: c.accent,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}