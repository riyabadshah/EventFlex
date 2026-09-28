import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import '../professional/professional_profile_screen.dart';

class ApplicationManagementScreen extends StatefulWidget {
  const ApplicationManagementScreen({super.key});

  @override
  State<ApplicationManagementScreen> createState() =>
      _ApplicationManagementScreenState();
}

class _ApplicationManagementScreenState
    extends State<ApplicationManagementScreen> {
  String _selectedStatusFilter = 'All';
  String _selectedEventFilter = 'All Events';

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final filteredApps = state.applications.where((app) {
          if (_selectedStatusFilter != 'All' && app.status != _selectedStatusFilter) {
            return false;
          }
          if (_selectedEventFilter != 'All Events' && app.eventName != _selectedEventFilter) {
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
                                'Candidate Applications',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Review, shortlist, or hire verified applicants for your staffing requirements.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${state.applications.length} Total Applicants',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDark,
                              ),
                            ),
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
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Event Filter
                            SizedBox(
                              width: 240,
                              child: DropdownButtonFormField<String>(
                                value: _selectedEventFilter,
                                decoration: const InputDecoration(
                                  labelText: 'Filter by Event',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                items: eventNames.map((e) {
                                  return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedEventFilter = val);
                                },
                              ),
                            ),

                            // Status Filter Chips
                            Wrap(
                              spacing: 8,
                              children: [
                                'All',
                                'Applied',
                                'Under Review',
                                'Shortlisted',
                                'Accepted',
                                'Rejected',
                              ].map((status) {
                                final isSelected = _selectedStatusFilter == status;
                                return ChoiceChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  selectedColor: AppTheme.primary,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.textDark,
                                    fontSize: 12,
                                  ),
                                  onSelected: (_) => setState(() => _selectedStatusFilter = status),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (filteredApps.isEmpty)
                        const EmptyStateWidget(
                          title: 'No Applications Match Filters',
                          subtitle: 'Applications submitted by event professionals will appear here.',
                        )
                      else
                        ...filteredApps.map((app) {
                          return _buildApplicationCard(context, app, state);
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

  Widget _buildApplicationCard(
    BuildContext context,
    JobApplication app,
    AppDataState state,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    app.professionalName.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primary),
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
                            app.professionalName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (app.isVerifiedPro)
                            const Icon(Icons.verified, color: AppTheme.primary, size: 16),
                          const Spacer(),
                          StatusBadge(status: app.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Applying for: ${app.roleName} • ${app.eventName}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RatingStars(rating: app.professionalRating, starSize: 13),
                          const SizedBox(width: 14),
                          Text(
                            '${app.professionalExperience} Exp • ${app.professionalLocation}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${app.matchScore}% Match',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Skills Chips
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: app.professionalSkills.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s, style: const TextStyle(fontSize: 11, color: AppTheme.textDark)),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Action Buttons (View Profile, Shortlist, Accept, Reject)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Rate: ₹${app.payment.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Find matching professional or show modal
                        final pro = state.allProfessionals.firstWhere(
                          (p) => p.name == app.professionalName,
                          orElse: () => state.currentProfessional,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfessionalProfileScreen(profile: pro),
                          ),
                        );
                      },
                      child: const Text('View Profile'),
                    ),
                    if (app.status != 'Shortlisted' && app.status != 'Accepted')
                      FilledButton.tonal(
                        onPressed: () {
                          state.updateApplicationStatus(app.id, 'Shortlisted');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.info,
                              content: Text('${app.professionalName} shortlisted!'),
                            ),
                          );
                        },
                        child: const Text('Shortlist'),
                      ),
                    if (app.status != 'Accepted')
                      FilledButton(
                        onPressed: () {
                          state.updateApplicationStatus(app.id, 'Accepted');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.success,
                              content: Text('Accepted ${app.professionalName}! Added to active workforce.'),
                            ),
                          );
                        },
                        child: const Text('Accept & Hire'),
                      ),
                    if (app.status != 'Rejected')
                      TextButton(
                        onPressed: () {
                          state.updateApplicationStatus(app.id, 'Rejected');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Application declined.')),
                          );
                        },
                        child: const Text('Decline', style: TextStyle(color: AppTheme.danger)),
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
}
