import 'package:flutter/material.dart';
import 'package:handsingdetection/theme/app_theme.dart';
import 'package:handsingdetection/utils/app_content.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c.gradStart, c.gradMid, c.gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              _topBar(context, c),

              // ── Scrollable content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // App icon + name
                      Center(
                        child: Column(children: [
                          Container(
                            width: 90, height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                c.accentSoft,
                                c.accent.withOpacity(0.3),
                              ]),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: c.accent.withOpacity(0.6),
                                  width: 2),
                            ),
                            child: Icon(Icons.pan_tool_alt,
                                color: c.accent, size: 40),
                          ),
                          const SizedBox(height: 14),
                          Text(AppContent.appName,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary)),
                          const SizedBox(height: 4),
                          Text('Version ${AppContent.appVersion}',
                              style: TextStyle(
                                  color: c.textMuted, fontSize: 13)),
                        ]),
                      ),

                      const SizedBox(height: 30),

                      // About the App
                      _sectionTitle(c, 'About the App'),
                      const SizedBox(height: 10),
                      _card(c,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(AppContent.appDescription,
                              style: TextStyle(
                                  color: c.textSecondary,
                                  fontSize: 14,
                                  height: 1.7)),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Team info
                      _sectionTitle(c, 'Development Team'),
                      const SizedBox(height: 10),
                      _card(c,
                        child: Column(children: [
                          _infoRow(c, Icons.group_outlined,
                              'Team', AppContent.teamName),
                          _rowDivider(c),
                          _infoRow(c, Icons.school_outlined,
                              'Institution', AppContent.institution),
                          _rowDivider(c),
                          _infoRow(c, Icons.email_outlined,
                              'Contact', AppContent.contactEmail),
                          _rowDivider(c),
                          _infoRow(c, Icons.code_outlined,
                              'GitHub', AppContent.githubUrl,
                              accent: true),
                        ]),
                      ),

                      const SizedBox(height: 24),

                      // Tech stack
                      _sectionTitle(c, 'Built With'),
                      const SizedBox(height: 10),
                      _card(c,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: AppContent.techStack
                                .map((t) => _techChip(c, t))
                                .toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: Text(
                          '© 2026 ${AppContent.teamName}. All rights reserved.',
                          style: TextStyle(
                              color: c.textMuted, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Widget _topBar(BuildContext context, AppColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: c.bgCard,
            shape: BoxShape.circle,
            border: Border.all(color: c.border),
          ),
          child: Icon(Icons.arrow_back_ios_new,
              color: c.textPrimary, size: 16),
        ),
      ),
      const SizedBox(width: 16),
      Text('About Us',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.textPrimary)),
    ]),
  );

  Widget _sectionTitle(AppColors c, String text) => Text(text,
      style: TextStyle(
          color: c.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16));

  Widget _card(AppColors c, {required Widget child}) => Container(
    decoration: BoxDecoration(
      color: c.bgCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.border),
      boxShadow: c.isDark
          ? []
          : [const BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: child,
  );

  Widget _rowDivider(AppColors c) =>
      Divider(color: c.border, height: 1, indent: 16, endIndent: 16);

  Widget _infoRow(AppColors c, IconData icon, String label, String value,
      {bool accent = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, color: c.accent, size: 20),
          const SizedBox(width: 12),
          Text('$label  ',
              style: TextStyle(
                  color: c.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: accent ? c.accent : c.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      );

  Widget _techChip(AppColors c, String label) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: c.accentSoft,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.accent.withOpacity(0.3)),
    ),
    child: Text(label,
        style: TextStyle(
            color: c.accent,
            fontSize: 12,
            fontWeight: FontWeight.w600)),
  );
}