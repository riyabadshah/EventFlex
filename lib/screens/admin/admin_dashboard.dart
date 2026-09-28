import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _activeTab = 'Verifications';

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final totalJobs = state.events.fold<int>(0, (acc, e) => acc + e.roles.length);
        final totalPaymentsAmount = state.payments.fold<double>(0, (acc, p) => acc + p.amount);

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'admin'),
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
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'GoWow Platform Admin Console',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Master platform governance, identity verification approvals, dispute escrow monitoring, and compliance.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Super Admin Mode',
                              style: TextStyle(
                                color: Color(0xFFB45309),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Platform Statistics (8 Key Metrics)
                      _buildPlatformStatsGrid(
                        context,
                        totalUsers: state.allProfessionals.length + 1,
                        organizersCount: 1,
                        professionalsCount: state.allProfessionals.length,
                        activeEventsCount: state.events.length,
                        activeJobsCount: totalJobs,
                        applicationsCount: state.applications.length,
                        completedAssignments: state.workforce.where((w) => w.status == 'Completed').length,
                        totalPayments: '₹${totalPaymentsAmount.toStringAsFixed(0)}',
                      ),

                      const SizedBox(height: 32),

                      // Tabs Bar
                      Wrap(
                        spacing: 12,
                        children: [
                          _tabBtn('Verifications & Compliance', 'Verifications'),
                          _tabBtn('Event Oversight', 'Events'),
                          _tabBtn('Escrow & Financial Audit', 'Finances'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Tab Content
                      if (_activeTab == 'Verifications')
                        _buildVerificationsTab(context, state)
                      else if (_activeTab == 'Events')
                        _buildEventsOversightTab(context, state)
                      else
                        _buildFinancialAuditTab(context, state),
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

  Widget _tabBtn(String label, String tabKey) {
    final isSelected = _activeTab == tabKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      onSelected: (_) => setState(() => _activeTab = tabKey),
    );
  }

  // --- 8 Platform Statistics ---
  Widget _buildPlatformStatsGrid(BuildContext context, {
    required int totalUsers,
    required int organizersCount,
    required int professionalsCount,
    required int activeEventsCount,
    required int activeJobsCount,
    required int applicationsCount,
    required int completedAssignments,
    required String totalPayments,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 950
            ? 4
            : constraints.maxWidth > 550
                ? 2
                : 1;

        final itemWidth = (constraints.maxWidth - ((crossCount - 1) * 14)) / crossCount;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Total Platform Users',
                value: '$totalUsers',
                icon: Icons.groups_rounded,
                iconColor: AppTheme.primary,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Verified Organizers',
                value: '$organizersCount',
                icon: Icons.business_center_rounded,
                iconColor: AppTheme.info,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Active Professionals',
                value: '$professionalsCount',
                icon: Icons.badge_rounded,
                iconColor: AppTheme.secondary,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Active Events',
                value: '$activeEventsCount',
                icon: Icons.event_available_rounded,
                iconColor: const Color(0xFF6366F1),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Marketplace Jobs',
                value: '$activeJobsCount',
                icon: Icons.work_outline_rounded,
                iconColor: AppTheme.accent,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Applications Logged',
                value: '$applicationsCount',
                icon: Icons.assignment_outlined,
                iconColor: AppTheme.info,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Completed Assignments',
                value: '$completedAssignments',
                icon: Icons.task_alt_rounded,
                iconColor: AppTheme.success,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: 'Escrow Volume',
                value: totalPayments,
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppTheme.success,
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Verifications Tab ---
  Widget _buildVerificationsTab(BuildContext context, AppDataState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identity & Professional Credentials Review',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Approve or reject verification badges after inspecting government ID documents.',
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 18),
        if (state.allProfessionals.isEmpty)
          const EmptyStateWidget(
            title: 'No Professionals Pending Verification',
            subtitle: 'New professional registrations will appear here for identity and document review.',
          )
        else
          ...state.allProfessionals.map((pro) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    pro.name.isNotEmpty ? pro.name[0] : 'P',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
                title: Row(
                  children: [
                    Text(pro.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    StatusBadge(status: pro.verificationStatus, isSmall: true),
                  ],
                ),
                subtitle: Text(
                  '${pro.eventType} • ${pro.location} • ${pro.experience} exp\nSkills: ${pro.skills.join(", ")}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    if (pro.verificationStatus != 'Verified')
                      FilledButton(
                        onPressed: () {
                          state.updateProfessionalVerification(pro.id, 'Verified');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.success,
                              content: Text('${pro.name} verified successfully!'),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(backgroundColor: AppTheme.success),
                        child: const Text('Approve ID'),
                      ),
                    if (pro.verificationStatus != 'Rejected')
                      OutlinedButton(
                        onPressed: () {
                          state.updateProfessionalVerification(pro.id, 'Rejected');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${pro.name} verification rejected.')),
                          );
                        },
                        child: const Text('Reject', style: TextStyle(color: AppTheme.danger)),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  // --- Events Oversight Tab ---
  Widget _buildEventsOversightTab(BuildContext context, AppDataState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Published Events Monitoring',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        if (state.events.isEmpty)
          const EmptyStateWidget(
            title: 'No Events Published Yet',
            subtitle: 'Events created by organizers will be listed here for compliance and safety audit.',
          )
        else
          ...state.events.map((ev) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(ev.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${ev.eventType} • ${ev.date} • ${ev.location}\nOrganizer: ${ev.organizerName} • Budget: ₹${ev.budget.toStringAsFixed(0)}',
                ),
                isThreeLine: true,
                trailing: StatusBadge(status: ev.status),
              ),
            );
          }),
      ],
    );
  }

  // --- Financial Audit Tab ---
  Widget _buildFinancialAuditTab(BuildContext context, AppDataState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Escrow Ledger & Settlement Audit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        if (state.payments.isEmpty)
          const EmptyStateWidget(
            title: 'No Payment Records Yet',
            subtitle: 'Escrow disbursements and transactions will appear here as event shifts are fulfilled.',
          )
        else
          ...state.payments.map((p) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: ListTile(
                title: Text('${p.eventName} — ₹${p.amount.toStringAsFixed(0)}'),
                subtitle: Text('Beneficiary: ${p.professionalName} | Payer: ${p.organizerName}\nTxn: ${p.transactionId}'),
                isThreeLine: true,
                trailing: StatusBadge(status: p.status, isSmall: true),
              ),
            );
          }),
      ],
    );
  }
}
