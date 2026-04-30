import 'package:flutter/material.dart';
import 'package:handsingdetection/theme/app_theme.dart';
import 'package:handsingdetection/utils/app_content.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                      // Last updated + intro
                      Text(
                        'Last updated: ${AppContent.termsLastUpdated}',
                        style: TextStyle(
                            color: c.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please read these terms carefully before using '
                            '${AppContent.appName}.',
                        style: TextStyle(
                            color: c.textSecondary,
                            fontSize: 14,
                            height: 1.6),
                      ),
                      const SizedBox(height: 20),

                      // Clause cards
                      ...AppContent.termsAndConditions.map((item) =>
                          _clauseCard(
                              c, item['heading']!, item['body']!)),

                      const SizedBox(height: 16),

                      // Footer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: c.border),
                        ),
                        child: Center(
                          child: Text(
                            '© 2026 ${AppContent.teamName}.\n'
                                'All rights reserved.',
                            style: TextStyle(
                                color: c.textMuted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
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

  // ── Clause card ────────────────────────────────────────────────────────

  Widget _clauseCard(AppColors c, String heading, String body) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border),
            boxShadow: c.isDark
                ? []
                : [const BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading,
                  style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              Text(body,
                  style: TextStyle(
                      color: c.textSecondary,
                      fontSize: 13,
                      height: 1.6)),
            ],
          ),
        ),
      );

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
      Text('Terms & Conditions',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.textPrimary)),
    ]),
  );
}