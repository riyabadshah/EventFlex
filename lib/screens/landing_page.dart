import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/footer.dart';
import '../widgets/navbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String selectedCategory = 'Conferences';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Conferences', 'icon': Icons.business_rounded},
    {'name': 'Weddings', 'icon': Icons.favorite_rounded},
    {'name': 'Corporate Events', 'icon': Icons.apartment_rounded},
    {'name': 'Exhibitions', 'icon': Icons.museum_rounded},
    {'name': 'Concerts', 'icon': Icons.music_note_rounded},
    {'name': 'Sports Events', 'icon': Icons.sports_soccer_rounded},
    {'name': 'Cultural Events', 'icon': Icons.theater_comedy_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const AppNavbar(activeRoute: 'home'),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION
            _buildHero(context, isDesktop),

            // 2. TRUST STATS BAR
            _buildTrustBar(context, isDesktop),

            // 3. FEATURED EVENT CATEGORIES
            _buildCategories(context, isDesktop),

            // 4. HOW GOWOW WORKS
            _buildHowItWorks(context, isDesktop),

            // 5. VALUE PROPOSITION: ORGANIZERS VS PROFESSIONALS
            _buildDualValueProp(context, isDesktop),

            // 6. WHY GOWOW (KEY ADVANTAGES)
            _buildWhyGoWow(context, isDesktop),

            // 7. TRUST & SAFETY
            _buildTrustAndSafety(context, isDesktop),

            // 8. TESTIMONIALS
            _buildTestimonials(context, isDesktop),

            // 9. FINAL CTA
            _buildFinalCTA(context, isDesktop),

            // 10. FOOTER
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // --- HERO SECTION ---
  Widget _buildHero(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // Dark slate
            Color(0xFF1E1B4B), // Deep indigo
            Color(0xFF312E81), // Rich purple indigo
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 80 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _heroContent(context, isDesktop),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      flex: 5,
                      child: _heroVisualCard(context),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _heroContent(context, isDesktop),
                    const SizedBox(height: 36),
                    _heroVisualCard(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _heroContent(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Top Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.stars_rounded, color: AppTheme.secondary, size: 16),
              SizedBox(width: 8),
              Text(
                'India’s Premier On-Demand Event Workforce Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Headline
        Text(
          'Find the Right People\nfor Every Event',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 52 : 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
            height: 1.15,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        // Subtext
        Text(
          'GoWow connects event organizers with verified, skilled, on-demand event professionals in minutes. From tech summits and luxury weddings to concerts and expos — staff with speed, transparency, and confidence.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 17 : 15,
            height: 1.6,
            color: const Color(0xFFCBD5E1),
          ),
        ),

        const SizedBox(height: 36),

        // CTAs
        Wrap(
          spacing: 16,
          runSpacing: 14,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () {
                AppDataState.instance.setRole('Organizer');
                Navigator.pushNamed(context, '/organizer');
              },
              icon: const Icon(Icons.group_add_rounded, size: 18),
              label: const Text('Find Event Staff'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                AppDataState.instance.setRole('Professional');
                Navigator.pushNamed(context, '/jobs');
              },
              icon: const Icon(Icons.work_outline_rounded, size: 18),
              label: const Text('Find Event Jobs'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Trust indicators
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            _trustIndicator('Verified Professionals'),
            _trustIndicator('Secure Hiring'),
            _trustIndicator('Transparent Payments'),
          ],
        ),
      ],
    );
  }

  Widget _trustIndicator(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppTheme.secondary, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _heroVisualCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.25),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE STAFFING DISPATCH',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Auto-Match Active',
                  style: TextStyle(
                    color: Color(0xFF818CF8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Real data or capability preview
          Builder(
            builder: (context) {
              final state = AppDataState.instance;
              final hasRealEvents = state.events.isNotEmpty && state.events.first.roles.isNotEmpty;
              final eventTitle = hasRealEvents ? state.events.first.name : 'Event Staffing Platform';
              final roleTitle = hasRealEvents
                  ? '${state.events.first.roles.first.name} • ${state.events.first.location}'
                  : 'Verified Professional Roles • Nationwide';
              final payText = hasRealEvents
                  ? '₹${state.events.first.roles.first.payment.toStringAsFixed(0)} / day'
                  : 'Transparent Payouts';

              final hasRealApps = state.applications.isNotEmpty;
              final applicantName = hasRealApps ? state.applications.first.professionalName : 'Verified Talent Pool';
              final applicantInitials = applicantName.isNotEmpty
                  ? applicantName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join()
                  : 'EF';
              final applicantSubtitle = hasRealApps
                  ? 'Status: ${state.applications.first.status} • Role: ${state.applications.first.roleName}'
                  : 'Skill Verified • Identity Checked';

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                eventTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const StatusBadge(status: 'Verified', isSmall: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          roleTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              payText,
                              style: const TextStyle(
                                color: AppTheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF065F46),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Smart Match',
                                style: TextStyle(
                                  color: Color(0xFF6EE7B7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryLight,
                          child: Text(
                            applicantInitials.isNotEmpty ? applicantInitials : 'PRO',
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applicantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                applicantSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const StatusBadge(status: 'Active', isSmall: true),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Attendance QR', style: TextStyle(color: Colors.white60, fontSize: 11)),
                    Text('Geo-Verified', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Escrow Payout', style: TextStyle(color: Colors.white60, fontSize: 11)),
                    Text('Direct Bank Transfer', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. TRUST STATS BAR ---
  Widget _buildTrustBar(BuildContext context, bool isDesktop) {
    final state = AppDataState.instance;
    final prosCount = state.allProfessionals.length;
    final eventsCount = state.events.length;
    final totalPayout = state.payments.fold<double>(0.0, (sum, p) => sum + p.amount);
    final attCount = state.workforce.length;
    final verifiedAtt = state.workforce.where((a) => a.checkInTime.isNotEmpty).length;
    final attendanceRate = attCount > 0 ? '${(verifiedAtt / attCount * 100).toStringAsFixed(1)}%' : '100%';

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 24,
            spacing: 36,
            children: [
              _metricItem('$prosCount', 'Verified Professionals', Icons.verified_user_rounded),
              _metricItem('$eventsCount', 'Active Events', Icons.event_available_rounded),
              _metricItem(attendanceRate, 'Verified Attendance', Icons.timer_rounded),
              _metricItem('₹${totalPayout.toStringAsFixed(0)}', 'Escrow Settlements', Icons.account_balance_wallet_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricItem(String value, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 24),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 3. FEATURED EVENT CATEGORIES ---
  Widget _buildCategories(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Column(
            children: [
              _sectionHeader(
                'FEATURED EVENT CATEGORIES',
                'Tailored Staffing for Every Occasion',
                'From intimate high-end weddings to massive stadium festivals, GoWow provides certified staff trained for your event archetype.',
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat['name'];
                  return ChoiceChip(
                    avatar: Icon(
                      cat['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : AppTheme.primary,
                    ),
                    label: Text(cat['name'] as String),
                    selected: isSelected,
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() {
                        selectedCategory = cat['name'] as String;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              // Filtered event cards preview
              _categoryCardsGrid(context, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCardsGrid(BuildContext context, bool isDesktop) {
    final state = AppDataState.instance;
    final filtered = state.events
        .where((e) =>
            e.eventType.toLowerCase().contains(selectedCategory.toLowerCase()) ||
            selectedCategory == 'Conferences')
        .toList();

    final displayEvents = filtered.isNotEmpty ? filtered : state.events;

    if (displayEvents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textMuted),
            const SizedBox(height: 12),
            const Text(
              'No events created yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Events created by organizers will appear here in real time.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                AppDataState.instance.setRole('Organizer');
                Navigator.pushNamed(context, '/organizer/create-event');
              },
              child: const Text('Post First Event'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: displayEvents.take(3).map((event) {
            return SizedBox(
              width: isDesktop ? 380 : double.infinity,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event.eventType,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          Text(
                            '${event.roles.length} Roles Open',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(event.location, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          const SizedBox(width: 14),
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(event.date, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.roles.isNotEmpty
                                ? 'Up to ₹${event.roles.map((r) => r.payment).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}/day'
                                : 'Competitive pay',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/jobs'),
                            child: const Text('View Positions →'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        FilledButton.tonal(
          onPressed: () => Navigator.pushNamed(context, '/jobs'),
          child: const Text('Explore All Marketplace Positions'),
        ),
      ],
    );
  }

  // --- 4. HOW GOWOW WORKS ---
  Widget _buildHowItWorks(BuildContext context, bool isDesktop) {
    return Container(
      color: AppTheme.surfaceSubtle,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Column(
            children: [
              _sectionHeader(
                'STREAMLINED WORKFLOW',
                'How GoWow Works',
                'From posting staffing requirements to attendance and instant payroll in 4 simple steps.',
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _stepCard(
                    step: '01',
                    title: 'Post Staffing Requirement',
                    desc: 'Organizers list event dates, roles (Hosts, Security, Tech, Volunteers), skills and daily compensation.',
                    icon: Icons.post_add_rounded,
                  ),
                  _stepCard(
                    step: '02',
                    title: 'Smart Match & Shortlist',
                    desc: 'Our AI engine matches candidates based on verified skills, location, ratings, and experience.',
                    icon: Icons.auto_awesome_rounded,
                  ),
                  _stepCard(
                    step: '03',
                    title: 'QR & GPS Attendance',
                    desc: 'Staff check in via on-site QR scanner. Organizers track attendance and live workforce in real time.',
                    icon: Icons.qr_code_scanner_rounded,
                  ),
                  _stepCard(
                    step: '04',
                    title: 'Automated Escrow Payout',
                    desc: 'After the event concludes, escrow funds are released directly to professionals with transparent ratings.',
                    icon: Icons.verified_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCard({
    required String step,
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 24),
              ),
              Text(
                step,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. DUAL VALUE PROP (ORGANIZERS VS PROFESSIONALS) ---
  Widget _buildDualValueProp(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Column(
            children: [
              _sectionHeader(
                'BUILT FOR THE ENTIRE ECOSYSTEM',
                'Empowering Organizers & Professionals',
                'Whether you are producing a festival for 20,000 fans or seeking premium event assignments, GoWow is your command center.',
              ),
              const SizedBox(height: 48),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _organizerValueCard(context)),
                        const SizedBox(width: 28),
                        Expanded(child: _professionalValueCard(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _organizerValueCard(context),
                        const SizedBox(height: 24),
                        _professionalValueCard(context),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _organizerValueCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business_center_rounded, color: AppTheme.primary, size: 24),
              ),
              const SizedBox(width: 14),
              const Text(
                'For Event Organizers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _bulletPoint('Zero Last-Minute No-Shows with verified candidate pools'),
          _bulletPoint('Instant Staffing Requirements with custom roles & wages'),
          _bulletPoint('Real-Time QR & GPS Attendance Monitoring on dashboard'),
          _bulletPoint('Escrow Budget Protection - pay only for verified work'),
          _bulletPoint('Automated Work History & Candidate Ratings'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              AppDataState.instance.setRole('Organizer');
              Navigator.pushNamed(context, '/organizer/create-event');
            },
            child: const Text('Post Staffing Requirement →'),
          ),
        ],
      ),
    );
  }

  Widget _professionalValueCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_pin_rounded, color: AppTheme.secondary, size: 24),
              ),
              const SizedBox(width: 14),
              const Text(
                'For Event Professionals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _bulletPointDark('Guaranteed On-Time Payouts via secure escrow'),
          _bulletPointDark('Verified Pro Badge to stand out to top organizers'),
          _bulletPointDark('1-Click Role Applications with match percentage'),
          _bulletPointDark('Work History Portfolio & portable client reviews'),
          _bulletPointDark('Flexible schedule - choose when & where you work'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              AppDataState.instance.setRole('Professional');
              Navigator.pushNamed(context, '/jobs');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.secondary,
              foregroundColor: const Color(0xFF0F172A),
            ),
            child: const Text('Discover Event Jobs →'),
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletPointDark(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.secondary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFFCBD5E1), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. WHY GOWOW ---
  Widget _buildWhyGoWow(BuildContext context, bool isDesktop) {
    return Container(
      color: AppTheme.surfaceSubtle,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Column(
            children: [
              _sectionHeader(
                'WHY CHOOSE GOWOW',
                'Built for Scalability, Security & Speed',
                'Traditional event staffing relies on unreliable chat groups and manual spreadsheets. GoWow modernizes the entire workflow.',
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _featureCard(
                    title: 'Smart Matching Engine',
                    desc: 'Match jobs against skills, language, previous event ratings, and geo-proximity within seconds.',
                    icon: Icons.bolt_rounded,
                  ),
                  _featureCard(
                    title: 'Live QR Check-In / Out',
                    desc: 'Eliminate buddy punching and ghost workers with GPS timestamped dynamic QR passes.',
                    icon: Icons.qr_code_2_rounded,
                  ),
                  _featureCard(
                    title: 'Instant Escrow Settlement',
                    desc: 'Funds are protected in escrow and disbursed immediately upon shift sign-off.',
                    icon: Icons.shield_rounded,
                  ),
                  _featureCard(
                    title: 'Verified Badges & Reviews',
                    desc: 'Government ID verification and bilateral 5-star review history guarantees elite work ethic.',
                    icon: Icons.star_rate_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard({
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- 7. TRUST & SAFETY ---
  Widget _buildTrustAndSafety(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Container(
            padding: EdgeInsets.all(isDesktop ? 48 : 24),
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                const Icon(Icons.security_rounded, color: AppTheme.secondary, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Trust & Safety at Every Step',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Every organizer and event professional goes through rigorous checks before entering the GoWow active marketplace.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 24,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _trustItem('Aadhaar / Gov ID Verification'),
                    _trustItem('Anti-No-Show Reliability Deposit'),
                    _trustItem('Bilateral Star Rating System'),
                    _trustItem('24/7 Rapid Dispute Resolution'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trustItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified_user_rounded, color: AppTheme.secondary, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // --- 8. TESTIMONIALS ---
  Widget _buildTestimonials(BuildContext context, bool isDesktop) {
    final state = AppDataState.instance;

    return Container(
      color: AppTheme.surfaceSubtle,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Column(
            children: [
              _sectionHeader(
                'COMMUNITY REPUTATION',
                'What Organizers & Pros Say',
                'Real reviews from professionals and event directors executing premier events on GoWow.',
              ),
              const SizedBox(height: 48),
              if (state.reviews.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.rate_review_outlined, size: 40, color: AppTheme.textMuted),
                      SizedBox(height: 12),
                      Text(
                        'No community reviews yet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Verified ratings and feedback will appear here as event shifts are completed.',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: state.reviews.map((rev) {
                    return Container(
                      width: isDesktop ? 420 : double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.primaryLight,
                                child: Text(
                                  rev.reviewerName.isNotEmpty ? rev.reviewerName[0] : 'U',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rev.reviewerName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      '${rev.reviewerRole} • ${rev.eventName}',
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              RatingStars(rating: rev.rating, starSize: 14),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '"${rev.comment}"',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textDark,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: rev.tags.map((t) => StatusBadge(status: t, isSmall: true)).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 9. FINAL CTA ---
  Widget _buildFinalCTA(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Text(
                'Ready to Transform Your Event Operations?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Join thousands of event organizers and verified professionals building the future of live events on GoWow / EventFlex.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      AppDataState.instance.setRole('Organizer');
                      Navigator.pushNamed(context, '/organizer/create-event');
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Post Your Event Staffing Needs', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      AppDataState.instance.setRole('Professional');
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Register as Verified Pro', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String overline, String title, String subtitle) {
    return Column(
      children: [
        Text(
          overline,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppTheme.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
