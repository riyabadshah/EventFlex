import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  String selectedEventTypeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final org = state.currentOrganizer;

        // Statistics
        final activeEventsCount = state.events.length;
        final totalOpenPositions = state.events.fold<int>(
          0,
          (sum, ev) =>
              sum +
              ev.roles.fold<int>(
                  0, (rSum, r) => rSum + (r.requiredPeople - r.hiredCount)),
        );
        final totalApplicationsCount = state.applications.length;
        final hiredStaffCount = state.workforce.length;
        final realTotalSpending = state.payments
            .where((p) => p.organizerName == org.companyName || p.organizerName == org.name)
            .fold<double>(0.0, (acc, p) => acc + p.amount);

        final attendanceRate = state.workforce.isNotEmpty
            ? (state.workforce.where((w) => w.attendanceStatus == 'Present').length /
                    state.workforce.length *
                    100)
                .toStringAsFixed(1)
            : '100.0';

        // Filtered events
        final filteredEvents = selectedEventTypeFilter == 'All'
            ? state.events
            : state.events
                .where((e) => e.eventType == selectedEventTypeFilter)
                .toList();

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'organizer'),
          endDrawer: const AppDrawer(),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 16,
                    vertical: 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Organizer Header & Quick Actions
                      _buildHeaderCard(context, org, isDesktop),

                      const SizedBox(height: 28),

                      // TOP STATISTICS (6 Key Metrics)
                      _buildTopStatistics(
                        context,
                        activeEvents: activeEventsCount,
                        openPositions: totalOpenPositions,
                        applications: totalApplicationsCount,
                        hiredStaff: hiredStaffCount,
                        attendanceRate: '$attendanceRate%',
                        totalSpending: '₹${(realTotalSpending > 0 ? realTotalSpending : org.totalSpent).toStringAsFixed(0)}',
                      ),

                      const SizedBox(height: 32),

                      // Quick Action Buttons Bar
                      _buildQuickActionButtons(context),

                      const SizedBox(height: 36),

                      // Desktop: 2 Columns | Mobile: Stacked
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: My Events & Staffing Requirements
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildMyEventsSection(context, filteredEvents, state),
                                      const SizedBox(height: 36),
                                      _buildOpenStaffingRequirementsSection(context, state),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 28),

                                // Right: Recent Candidate Applications & Workforce Status
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildRecentApplicationsCard(context, state),
                                      const SizedBox(height: 28),
                                      _buildWorkforceOverviewCard(context, state),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMyEventsSection(context, filteredEvents, state),
                                const SizedBox(height: 28),
                                _buildOpenStaffingRequirementsSection(context, state),
                                const SizedBox(height: 28),
                                _buildRecentApplicationsCard(context, state),
                                const SizedBox(height: 28),
                                _buildWorkforceOverviewCard(context, state),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Organizer Header Card ---
  Widget _buildHeaderCard(
    BuildContext context,
    OrganizerProfile org,
    bool isDesktop,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(28),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.business_center_rounded, color: AppTheme.primary, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      org.companyName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: org.verificationStatus),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Event Director: ${org.name} • ${org.location} • Verified Escrow Partner',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/organizer/create-event'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create New Event'),
            ),
          ],
        ],
      ),
    );
  }

  // --- Top Statistics Grid (6 Metrics) ---
  Widget _buildTopStatistics(
    BuildContext context, {
    required int activeEvents,
    required int openPositions,
    required int applications,
    required int hiredStaff,
    required String attendanceRate,
    required String totalSpending,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 950
            ? 6
            : constraints.maxWidth > 650
                ? 3
                : 2;

        final itemWidth =
            (constraints.maxWidth - ((crossCount - 1) * 14)) / crossCount;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Active Events',
                value: '$activeEvents',
                icon: Icons.calendar_today_rounded,
                iconColor: AppTheme.primary,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Open Positions',
                value: '$openPositions',
                icon: Icons.person_search_rounded,
                iconColor: AppTheme.accent,
                badgeText: 'Hiring',
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Applications',
                value: '$applications',
                icon: Icons.assignment_outlined,
                iconColor: AppTheme.info,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Hired Staff',
                value: '$hiredStaff',
                icon: Icons.badge_rounded,
                iconColor: AppTheme.secondary,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Attendance',
                value: attendanceRate,
                icon: Icons.qr_code_scanner_rounded,
                iconColor: AppTheme.success,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Total Spending',
                value: totalSpending,
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF6366F1),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Quick Action Buttons Bar ---
  Widget _buildQuickActionButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceSubtle,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          _quickBtn(
            context,
            'Create Event',
            Icons.add_circle_outline,
            '/organizer/create-event',
            isPrimary: true,
          ),
          _quickBtn(
            context,
            'Post Staffing Role',
            Icons.work_outline,
            '/organizer/post-requirement',
          ),
          _quickBtn(
            context,
            'View Applications',
            Icons.people_outline,
            '/organizer/applications',
          ),
          _quickBtn(
            context,
            'Workforce & Attendance',
            Icons.fact_check_outlined,
            '/organizer/workforce',
          ),
          _quickBtn(
            context,
            'Smart Matching Engine',
            Icons.auto_awesome_rounded,
            '/smart-match',
          ),
          _quickBtn(
            context,
            'Manage Payments',
            Icons.payments_outlined,
            '/payments',
          ),
        ],
      ),
    );
  }

  Widget _quickBtn(
    BuildContext context,
    String label,
    IconData icon,
    String route, {
    bool isPrimary = false,
  }) {
    return isPrimary
        ? FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, route),
            icon: Icon(icon, size: 16),
            label: Text(label),
          )
        : OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, route),
            icon: Icon(icon, size: 16),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          );
  }

  // --- My Events Section ---
  Widget _buildMyEventsSection(
    BuildContext context,
    List<EventItem> eventList,
    AppDataState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pushNamed(context, '/organizer/create-event'),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Event'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Event Type Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['All', ...eventTypes.take(6)].map((type) {
            final isSelected = selectedEventTypeFilter == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              selectedColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => setState(() => selectedEventTypeFilter = type),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        if (eventList.isEmpty)
          const EmptyStateWidget(
            title: 'No Events for Selected Category',
            subtitle: 'Create a new event and configure custom staffing roles in seconds.',
          )
        else
          ...eventList.map((event) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
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
                                  const SizedBox(width: 8),
                                  StatusBadge(status: event.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                event.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            if (val == 'post_role') {
                              Navigator.pushNamed(context, '/organizer/post-requirement');
                            } else if (val == 'apps') {
                              Navigator.pushNamed(context, '/organizer/applications');
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'post_role', child: Text('Add Staffing Role')),
                            PopupMenuItem(value: 'apps', child: Text('Review Applications')),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
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
                        Text('${event.date} • ${event.time}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Staffing Roles overview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${event.roles.length} Staffing Roles • ${event.totalWorkersHired}/${event.totalWorkersNeeded} Hired',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/organizer/post-requirement'),
                              icon: const Icon(Icons.add, size: 14),
                              label: const Text('Add Role'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: () => Navigator.pushNamed(context, '/organizer/applications'),
                              child: const Text('Applications'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  // --- Open Staffing Requirements Section ---
  Widget _buildOpenStaffingRequirementsSection(
    BuildContext context,
    AppDataState state,
  ) {
    final List<Map<String, dynamic>> openRoles = [];
    for (var ev in state.events) {
      for (var r in ev.roles) {
        if (r.hiredCount < r.requiredPeople) {
          openRoles.add({'role': r, 'event': ev});
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Open Staffing Requirements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/organizer/post-requirement'),
              child: const Text('Post New Requirement +'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (openRoles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No open staffing positions. Create a staffing role to recruit professionals.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          )
        else
          ...openRoles.take(3).map((item) {
            final StaffingRole r = item['role'];
            final EventItem ev = item['event'];

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryLight,
                  child: const Icon(Icons.people_outline, color: AppTheme.primary),
                ),
                title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${ev.name}\n${r.requiredPeople - r.hiredCount} positions remaining • ₹${r.payment.toStringAsFixed(0)}/day',
                ),
                isThreeLine: true,
                trailing: FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, '/smart-match'),
                  child: const Text('Match Pros'),
                ),
              ),
            );
          }),
      ],
    );
  }

  // --- Recent Applications Card ---
  Widget _buildRecentApplicationsCard(BuildContext context, AppDataState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Candidate Applications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/organizer/applications'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (state.applications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No candidate applications received yet.',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            )
          else
            ...state.applications.take(3).map((app) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        app.professionalName.isNotEmpty ? app.professionalName[0] : 'A',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.professionalName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            'Applied for ${app.roleName}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: app.status, isSmall: true),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // --- Workforce Overview Card ---
  Widget _buildWorkforceOverviewCard(BuildContext context, AppDataState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'On-Site Workforce & Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/organizer/workforce'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.workforce.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No staff assigned to shifts yet.',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            )
          else
            ...state.workforce.take(3).map((wf) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: wf.attendanceStatus == 'Present' ? AppTheme.success : AppTheme.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(wf.professionalName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('${wf.role} • ${wf.attendanceStatus}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    StatusBadge(status: wf.status, isSmall: true),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => Navigator.pushNamed(context, '/attendance'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 16),
                SizedBox(width: 8),
                Text('Launch Venue QR Scanner Hub'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
