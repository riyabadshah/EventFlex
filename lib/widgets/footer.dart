import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark slate
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 48,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand column
              Expanded(
                flex: isDesktop ? 3 : 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GoWowLogo(size: 36, isDark: true),
                    const SizedBox(height: 16),
                    const Text(
                      'GoWow / EventFlex is India’s next-generation digital event staffing infrastructure connecting top event organizers with verified, on-demand event professionals.',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      children: [
                        _trustPill('100% Identity Verified'),
                        _trustPill('Secure Escrow Payouts'),
                        _trustPill('GPS & QR Attendance'),
                      ],
                    ),
                  ],
                ),
              ),

              if (isDesktop) ...[
                const SizedBox(width: 48),

                // Quick links: For Organizers
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FOR ORGANIZERS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _footerLink(context, 'Create New Event', '/organizer/create-event'),
                      _footerLink(context, 'Post Staffing Role', '/organizer/post-requirement'),
                      _footerLink(context, 'Candidate Applications', '/organizer/applications'),
                      _footerLink(context, 'Workforce & Attendance', '/organizer/workforce'),
                      _footerLink(context, 'Smart Match Engine', '/smart-match'),
                    ],
                  ),
                ),

                // Quick links: For Professionals
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FOR PROFESSIONALS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _footerLink(context, 'Find Event Jobs', '/jobs'),
                      _footerLink(context, 'My Applications', '/professional'),
                      _footerLink(context, 'Complete Pro Profile', '/professional/profile'),
                      _footerLink(context, 'Attendance QR Scanner', '/attendance'),
                      _footerLink(context, 'Earnings & Payouts', '/payments'),
                    ],
                  ),
                ),

                // Quick links: Event Categories
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EVENT TYPES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _footerText('Tech Conferences & Summits'),
                      _footerText('Weddings & Galas'),
                      _footerText('Corporate Expos & Launches'),
                      _footerText('Music Concerts & Festivals'),
                      _footerText('Marathons & Sports Tournaments'),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 40),
          const Divider(color: Color(0xFF1E293B)),
          const SizedBox(height: 20),

          // Bottom Bar
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            spacing: 16,
            children: [
              const Text(
                '© 2026 GoWow EventFlex Technologies Inc. All rights reserved.',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/admin'),
                    child: const Text(
                      'Admin Console',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Terms • Privacy • Node.js/Mongo API Ready',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trustPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.secondary, size: 12),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _footerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 13,
        ),
      ),
    );
  }
}
