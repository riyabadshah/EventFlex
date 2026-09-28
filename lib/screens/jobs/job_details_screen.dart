import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class JobDetailsScreen extends StatefulWidget {
  final StaffingRole role;
  final EventItem event;

  const JobDetailsScreen({
    super.key,
    required this.role,
    required this.event,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _coverNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);
    final role = widget.role;
    final event = widget.event;

    final hasApplied = state.applications.any(
      (a) => a.jobId == role.id && a.professionalId == state.currentProfessional.id,
    );

    final appStatus = hasApplied
        ? state.applications
            .firstWhere((a) => a.jobId == role.id && a.professionalId == state.currentProfessional.id)
            .status
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Position Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : 16,
                vertical: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Header Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.softShadow,
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(height: 12),
                                  Text(
                                    role.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${event.name} • Organized by ${event.organizerName}',
                                    style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${role.payment.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  const Text(
                                    'Daily Shift Rate',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF166534),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Key Highlights Grid
                        Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          children: [
                            _highlightItem(Icons.calendar_today_rounded, 'Date', role.date.isNotEmpty ? role.date : event.date),
                            _highlightItem(Icons.schedule_rounded, 'Hours', role.workingHours),
                            _highlightItem(Icons.location_on_rounded, 'Location', role.location.isNotEmpty ? role.location : event.location),
                            _highlightItem(Icons.people_alt_rounded, 'Required Openings', '${role.requiredPeople} Positions (${role.hiredCount} Filled)'),
                            _highlightItem(Icons.timeline_rounded, 'Min Experience', role.experienceRequired),
                            _highlightItem(Icons.verified_rounded, 'Organizer Status', 'Verified & Escrow Funded'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Job Description & Required Skills
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Role Responsibilities',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          role.description,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Required Skills & Expertise',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: role.requiredSkills.split(',').map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                skill.trim(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Event Overview
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Event Overview',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          event.description,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.5),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.group_outlined, color: AppTheme.textMuted, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Expected Attendance: ${event.expectedAttendance}',
                              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Apply Card / Status Banner
                  Container(
                    decoration: BoxDecoration(
                      color: hasApplied ? const Color(0xFFF0FDF4) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: hasApplied ? const Color(0xFF86EFAC) : AppTheme.border,
                        width: hasApplied ? 2 : 1,
                      ),
                      boxShadow: AppTheme.softShadow,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: hasApplied
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, color: Color(0xFF15803D), size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Application Submitted!',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'The organizer is reviewing your profile. Current Status: $appStatus',
                                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(status: appStatus ?? 'Applied'),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Submit Your Application',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Applying as ${state.currentProfessional.name} (${state.currentProfessional.rating} ★, ${state.currentProfessional.experience} exp)',
                                style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _coverNoteController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  labelText: 'Quick Cover Note / Relevant Experience (Optional)',
                                  hintText: 'e.g. Handled registration at TechSummit BKC with RFID kiosks',
                                ),
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: () {
                                  state.applyForJob(role, event);
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTheme.success,
                                      content: Text('Successfully applied for ${role.name}!'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.send_rounded),
                                label: const Text('Confirm & Apply for Role'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _highlightItem(IconData icon, String label, String value) {
    return SizedBox(
      width: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
