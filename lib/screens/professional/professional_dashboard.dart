import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import '../jobs/job_details_screen.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends State<ProfessionalDashboardScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final pro = state.currentProfessional;
        final myApps = state.applications
            .where((a) => a.professionalId == pro.id)
            .toList();
        final activeAssignments = state.workforce
            .where((w) => w.professionalId == pro.id)
            .toList();

        // Calculate real earnings from completed payments
        final realEarnings = state.payments
            .where((p) => p.professionalName == pro.name && p.status == 'Paid')
            .fold<double>(0.0, (acc, p) => acc + p.amount);

        // Calculate available jobs count across all events
        final totalAvailableJobs = state.events.fold<int>(
            0, (sum, ev) => sum + ev.roles.length);

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'professional'),
          endDrawer: const AppDrawer(),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 16,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Profile Summary & Completion Bar
                      _buildProfileHeaderCard(context, pro, isDesktop),

                      const SizedBox(height: 28),

                      // TOP STATISTICS CARDS
                      _buildTopStatistics(
                        context,
                        availableJobs: totalAvailableJobs,
                        applicationsCount: myApps.length,
                        activeAssignmentsCount: activeAssignments.length,
                        totalEarnings: realEarnings > 0 ? realEarnings : pro.totalEarnings,
                      ),

                      const SizedBox(height: 36),

                      // Two-Column or Stacked Dashboard Layout
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Column: Recommended Jobs & Nearby Jobs
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildRecommendedJobsSection(context, state),
                                      const SizedBox(height: 36),
                                      _buildMyApplicationsSection(context, myApps),
                                      const SizedBox(height: 36),
                                      _buildAssignmentsSection(context, activeAssignments),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 28),

                                // Right Column: Upcoming Events & Recent Payments
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildUpcomingSchedule(context, state),
                                      const SizedBox(height: 28),
                                      _buildRecentPaymentsCard(context, state, pro),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRecommendedJobsSection(context, state),
                                const SizedBox(height: 28),
                                _buildMyApplicationsSection(context, myApps),
                                const SizedBox(height: 28),
                                _buildAssignmentsSection(context, activeAssignments),
                                const SizedBox(height: 28),
                                _buildUpcomingSchedule(context, state),
                                const SizedBox(height: 28),
                                _buildRecentPaymentsCard(context, state, pro),
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

  // --- Profile Header Card with Profile Completion ---
  Widget _buildProfileHeaderCard(
    BuildContext context,
    ProfessionalProfile pro,
    bool isDesktop,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  pro.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pro.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(status: pro.verificationStatus),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pro.experience} Experience • ${pro.location} • Preferred: ${pro.eventType}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        RatingStars(rating: pro.rating, starSize: 15),
                        Text(
                          '${pro.completedJobs} Completed Jobs',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/professional/profile'),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Edit Profile'),
                ),
              ],
            ],
          ),
          if (!isDesktop) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/professional/profile'),
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Edit Profile'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Profile Completion Meter
          Row(
            children: [
              const Icon(Icons.speed_rounded, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile Completion',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${pro.profileCompletion}% Complete',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: pro.profileCompletion / 100.0,
                        backgroundColor: AppTheme.surfaceSubtle,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/professional/profile'),
                child: const Text('Complete Now (+15%)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Top Statistics Grid ---
  Widget _buildTopStatistics(
    BuildContext context, {
    required int availableJobs,
    required int applicationsCount,
    required int activeAssignmentsCount,
    required double totalEarnings,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 550
                ? 2
                : 1;

        final itemWidth =
            (constraints.maxWidth - ((crossCount - 1) * 16)) / crossCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Available Jobs',
                value: '$availableJobs Roles',
                subtitle: 'Across active events',
                icon: Icons.search_rounded,
                iconColor: AppTheme.primary,
                badgeText: 'New Today',
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Applications',
                value: '$applicationsCount Active',
                subtitle: 'Track review status',
                icon: Icons.assignment_outlined,
                iconColor: AppTheme.info,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Active Assignments',
                value: '$activeAssignmentsCount Confirmed',
                subtitle: 'Upcoming shifts',
                icon: Icons.event_available_rounded,
                iconColor: AppTheme.secondary,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Total Earnings',
                value: '₹${totalEarnings.toStringAsFixed(0)}',
                subtitle: 'Via secure escrow',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppTheme.success,
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Recommended Jobs Section ---
  Widget _buildRecommendedJobsSection(BuildContext context, AppDataState state) {
    // Show top roles matching professional
    final List<Map<String, dynamic>> jobList = [];
    for (var ev in state.events) {
      for (var r in ev.roles) {
        jobList.add({'role': r, 'event': ev});
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended & Nearby Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/jobs'),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All in Marketplace'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (jobList.isEmpty)
          const EmptyStateWidget(
            title: 'No Recommended Jobs Available Yet',
            subtitle: 'Check back soon as new event positions are posted by organizers.',
          )
        else
          ...jobList.take(3).map((item) {
            final StaffingRole role = item['role'];
            final EventItem event = item['event'];

            final hasApplied = state.applications.any((a) =>
                a.jobId == role.id &&
                a.professionalId == state.currentProfessional.id);

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              role.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${event.name} • ${event.organizerName}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '₹${role.payment.toStringAsFixed(0)} / day',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(event.location, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      const SizedBox(width: 14),
                      const Icon(Icons.schedule_rounded, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(role.workingHours, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      const SizedBox(width: 14),
                      const Icon(Icons.people_outline, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text('${role.requiredPeople} required', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 6,
                        children: role.requiredSkills
                            .split(',')
                            .take(2)
                            .map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceSubtle,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(s.trim(), style: const TextStyle(fontSize: 11)),
                                ))
                            .toList(),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JobDetailsScreen(role: role, event: event),
                                ),
                              );
                            },
                            child: const Text('Details'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: hasApplied
                                ? null
                                : () {
                                    state.applyForJob(role, event);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppTheme.success,
                                        content: Text('Applied for ${role.name}!'),
                                      ),
                                    );
                                  },
                            child: Text(hasApplied ? 'Applied ✓' : 'Apply Now'),
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

  // --- My Applications Section ---
  Widget _buildMyApplicationsSection(
      BuildContext context, List<JobApplication> myApps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Applications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        if (myApps.isEmpty)
          const EmptyStateWidget(
            title: 'No Applications Yet',
            subtitle: 'Explore the job marketplace and apply with a single click!',
          )
        else
          ...myApps.map((app) {
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
                  child: const Icon(Icons.assignment_turned_in_outlined, color: AppTheme.primary),
                ),
                title: Text(
                  app.roleName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  '${app.eventName} • ${app.eventDate}\nCompensation: ₹${app.payment.toStringAsFixed(0)}',
                ),
                isThreeLine: true,
                trailing: StatusBadge(status: app.status),
              ),
            );
          }),
      ],
    );
  }

  // --- Current Assignments Section ---
  Widget _buildAssignmentsSection(
      BuildContext context, List<WorkforceMember> assignments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Assignments & Shifts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/attendance'),
              icon: const Icon(Icons.qr_code_scanner, size: 16),
              label: const Text('Open QR Attendance'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (assignments.isEmpty)
          const EmptyStateWidget(
            title: 'No Current Shifts',
            subtitle: 'When an organizer accepts your application, your shift assignment will appear here.',
          )
        else
          ...assignments.map((wf) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.badge_rounded, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wf.role,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            '${wf.eventName} • Date: ${wf.date}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Check-in: ${wf.checkInTime} • Check-out: ${wf.checkOutTime}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.primaryDark),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadge(status: wf.status),
                        const SizedBox(height: 6),
                        Text(
                          '₹${wf.paymentAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

  // --- Upcoming Schedule Card ---
  Widget _buildUpcomingSchedule(BuildContext context, AppDataState state) {
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
            children: const [
              Text(
                'Upcoming Events Calendar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.calendar_month_rounded, color: AppTheme.primary, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          if (state.events.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No upcoming events scheduled yet.',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            )
          else
            ...state.events.take(3).map((e) {
              final dateParts = e.date.split('-');
              final day = dateParts.isNotEmpty ? dateParts.last : '01';
              final month = dateParts.length > 1
                  ? (dateParts[1] == '10'
                      ? 'OCT'
                      : dateParts[1] == '11'
                          ? 'NOV'
                          : 'DEC')
                  : 'EVT';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            month,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${e.time} • ${e.location}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // --- Recent Payments Card ---
  Widget _buildRecentPaymentsCard(
    BuildContext context,
    AppDataState state,
    ProfessionalProfile pro,
  ) {
    final proPayments = state.payments
        .where((p) => p.professionalName == pro.name)
        .toList();

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
                'Recent Payouts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/payments'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (proPayments.isEmpty)
            const Text(
              'No payout history yet.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            )
          else
            ...proPayments.take(3).map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_downward, color: Color(0xFF15803D), size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.eventName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${p.role} • ${p.date}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+₹${p.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
