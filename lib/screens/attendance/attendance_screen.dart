import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedEventId;

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (state.events.isEmpty) {
          return Scaffold(
            appBar: const AppNavbar(activeRoute: 'attendance'),
            endDrawer: const AppDrawer(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded, size: 64, color: AppTheme.textMuted),
                    const SizedBox(height: 16),
                    const Text(
                      'No events created yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Attendance rosters and venue QR codes will appear here once an event is created.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        state.setRole('Organizer');
                        Navigator.pushNamed(context, '/organizer/create-event');
                      },
                      child: const Text('Create New Event'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final currentEvent = state.events.firstWhere(
          (e) => e.id == _selectedEventId,
          orElse: () => state.events.first,
        );
        _selectedEventId = currentEvent.id;

        final eventWorkforce = state.workforce
            .where((w) => w.eventId == currentEvent.id)
            .toList();

        final presentCount =
            eventWorkforce.where((w) => w.attendanceStatus == 'Present').length;
        final lateCount =
            eventWorkforce.where((w) => w.attendanceStatus == 'Late').length;
        final absentCount =
            eventWorkforce.where((w) => w.attendanceStatus == 'Absent').length;

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'attendance'),
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
                                'QR & GPS Attendance System',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Real-time on-site verification to eliminate buddy punching and ensure 100% on-time staff.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => QrScannerModal(
                                  eventName: currentEvent.name,
                                  roleName: 'Venue Entry Scan',
                                  onScanned: () {
                                    if (eventWorkforce.isNotEmpty) {
                                      state.markAttendance(
                                        eventWorkforce.first.id,
                                        'Present',
                                        checkIn: TimeOfDay.now().format(context),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_scanner, size: 18),
                            label: const Text('Scan QR to Check In'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Event Selector & Attendance Stats Banner
                      _buildEventSelectorCard(context, currentEvent, state),

                      const SizedBox(height: 24),

                      // Attendance Metrics Counters
                      Row(
                        children: [
                          Expanded(
                            child: _attendanceMetricCard('Present', '$presentCount', Icons.check_circle_rounded, const Color(0xFF15803D), const Color(0xFFDCFCE7)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _attendanceMetricCard('Late Arrivals', '$lateCount', Icons.warning_rounded, const Color(0xFFC2410C), const Color(0xFFFFEDD5)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _attendanceMetricCard('Absent / No-Show', '$absentCount', Icons.cancel_rounded, const Color(0xFFB91C1C), const Color(0xFFFEE2E2)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Venue QR Display Card (for Event Organizer)
                      _buildVenueQrDisplayCard(context, currentEvent),

                      const SizedBox(height: 28),

                      // Attendance Roster Table / Cards
                      const Text(
                        'On-Site Workforce Attendance Roster',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (eventWorkforce.isEmpty)
                        const EmptyStateWidget(
                          title: 'No Workers Assigned to This Event',
                          subtitle: 'Once candidates are accepted from Applications, they appear on this roster.',
                        )
                      else
                        ...eventWorkforce.map((member) {
                          return _buildRosterCard(context, member, state);
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

  Widget _buildEventSelectorCard(
    BuildContext context,
    EventItem currentEvent,
    AppDataState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.event, color: AppTheme.primary, size: 24),
          const SizedBox(width: 12),
          const Text('Active Event: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedEventId,
              underline: const SizedBox(),
              items: state.events.map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(
                    '${e.name} (${e.location})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedEventId = val);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              currentEvent.date,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceMetricCard(
    String label,
    String count,
    IconData icon,
    Color fg,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 26),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: fg,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Venue QR Display Card for Organizer ---
  Widget _buildVenueQrDisplayCard(BuildContext context, EventItem event) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(28),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: Color(0xFF0F172A),
              size: 76,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Display Venue Attendance QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Show this dynamic QR code at the check-in desk at ${event.location}. Professionals scan it on their phone to timestamp their shift arrival.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.gps_fixed, color: AppTheme.secondary, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Geo-Fenced: Within 100 meters of venue coordinates',
                      style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Roster Item Card ---
  Widget _buildRosterCard(
    BuildContext context,
    WorkforceMember member,
    AppDataState state,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
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
                    children: [
                      Text(
                        member.professionalName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(status: member.attendanceStatus, isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${member.role} • Total: ${member.totalHours}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Check-In: ${member.checkInTime}   |   Check-Out: ${member.checkOutTime}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () {
                    state.markAttendance(
                      member.id,
                      'Present',
                      checkIn: TimeOfDay.now().format(context),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checked In: ${member.professionalName}')),
                    );
                  },
                  child: const Text('Check In'),
                ),
                OutlinedButton(
                  onPressed: () {
                    state.markAttendance(
                      member.id,
                      'Present',
                      checkOut: TimeOfDay.now().format(context),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checked Out: ${member.professionalName}')),
                    );
                  },
                  child: const Text('Check Out'),
                ),
                PopupMenuButton<String>(
                  onSelected: (val) {
                    state.markAttendance(member.id, val);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Present', child: Text('Mark Present')),
                    PopupMenuItem(value: 'Late', child: Text('Mark Late')),
                    PopupMenuItem(value: 'Absent', child: Text('Mark Absent')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.more_vert, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
