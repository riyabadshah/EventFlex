import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import '../professional/professional_profile_screen.dart';

class WorkforceManagementScreen extends StatefulWidget {
  const WorkforceManagementScreen({super.key});

  @override
  State<WorkforceManagementScreen> createState() =>
      _WorkforceManagementScreenState();
}

class _WorkforceManagementScreenState extends State<WorkforceManagementScreen> {
  String _selectedEvent = 'All Events';

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final filteredWorkforce = state.workforce.where((w) {
          if (_selectedEvent != 'All Events' && w.eventName != _selectedEvent) {
            return false;
          }
          return true;
        }).toList();

        final eventNames = [
          'All Events',
          ...state.events.map((e) => e.name).toSet(),
        ];

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
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Workforce & Live Roster',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Manage hired event professionals, track real-time attendance, and approve escrow disbursements.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          FilledButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/attendance'),
                            icon: const Icon(Icons.qr_code_scanner, size: 16),
                            label: const Text('Open QR Attendance'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Filter Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            const Text('Event Roster: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 12),
                            DropdownButton<String>(
                              value: _selectedEvent,
                              underline: const SizedBox(),
                              items: eventNames.map((e) {
                                return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedEvent = val);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (filteredWorkforce.isEmpty)
                        const EmptyStateWidget(
                          title: 'No Hired Workforce on Roster',
                          subtitle: 'Accept applicants from the Applications tab to add them to your live event workforce.',
                        )
                      else
                        ...filteredWorkforce.map((member) {
                          return _buildWorkforceCard(context, member, state);
                        }),
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

  Widget _buildWorkforceCard(
    BuildContext context,
    WorkforceMember member,
    AppDataState state,
  ) {
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    member.professionalName.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            member.professionalName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                          StatusBadge(status: member.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Role: ${member.role} • ${member.eventName}',
                        style: const TextStyle(fontSize: 13, color: AppTheme.primaryDark, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        children: [
                          _badgeRow(Icons.calendar_today, member.date),
                          _badgeRow(Icons.timer_outlined, 'Logged: ${member.totalHours} (${member.checkInTime} - ${member.checkOutTime})'),
                          _badgeRow(Icons.star_rounded, '${member.performanceRating} Performance'),
                          _badgeRow(Icons.currency_rupee, '₹${member.paymentAmount.toStringAsFixed(0)} (${member.paymentStatus})'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Actions: Attendance, Contact, Payment, View Profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Attendance: ', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    StatusBadge(status: member.attendanceStatus, isSmall: true),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        final pro = state.allProfessionals.firstWhere(
                          (p) => p.name == member.professionalName,
                          orElse: () => state.currentProfessional,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfessionalProfileScreen(profile: pro),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_outline, size: 14),
                      label: const Text('Profile'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/messages'),
                      icon: const Icon(Icons.chat_bubble_outline, size: 14),
                      label: const Text('Contact'),
                    ),
                    if (member.attendanceStatus != 'Present')
                      FilledButton.tonal(
                        onPressed: () {
                          state.markAttendance(member.id, 'Present', checkIn: '08:00 AM');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.success,
                              content: Text('Marked ${member.professionalName} as Present!'),
                            ),
                          );
                        },
                        child: const Text('Mark Present'),
                      ),
                    if (member.paymentStatus != 'Paid')
                      FilledButton(
                        onPressed: () {
                          state.markWorkforcePaid(member.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.success,
                              content: Text('Transferred ₹${member.paymentAmount.toStringAsFixed(0)} to ${member.professionalName}!'),
                            ),
                          );
                        },
                        child: Text('Pay ₹${member.paymentAmount.toStringAsFixed(0)}'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }
}
