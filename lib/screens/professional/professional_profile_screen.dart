import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import 'dynamic_profile_edit.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  final ProfessionalProfile? profile;

  const ProfessionalProfileScreen({super.key, this.profile});

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  late ProfessionalProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile ?? AppDataState.instance.currentProfessional;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final state = AppDataState.instance;

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
                vertical: 36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Hero Banner & Card
                  _buildProfileHeroCard(context, isDesktop),

                  const SizedBox(height: 28),

                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Skills, Certifications, Availability, Dynamic Details)
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  _buildSkillsAndCertificationsCard(),
                                  const SizedBox(height: 24),
                                  _buildDynamicProfileFieldsCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 28),

                            // Right Column (Work History Timeline & Reviews)
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _buildWorkHistoryCard(state),
                                  const SizedBox(height: 24),
                                  _buildClientReviewsCard(state),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildSkillsAndCertificationsCard(),
                            const SizedBox(height: 20),
                            _buildDynamicProfileFieldsCard(),
                            const SizedBox(height: 20),
                            _buildWorkHistoryCard(state),
                            const SizedBox(height: 20),
                            _buildClientReviewsCard(state),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Profile Hero Card ---
  Widget _buildProfileHeroCard(BuildContext context, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 46,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  _profile.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _profile.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(width: 10),
                        StatusBadge(status: _profile.verificationStatus),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_profile.experience} Experience • Based in ${_profile.location}',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        RatingStars(rating: _profile.rating, starSize: 16),
                        _statChip(Icons.work_outline, '${_profile.completedJobs} Events Completed'),
                        _statChip(Icons.currency_rupee, '₹${_profile.totalEarnings.toStringAsFixed(0)} Earned'),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DynamicProfileEdit(profile: _profile),
                          ),
                        );
                        setState(() {});
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Full Profile'),
                    ),
                    const SizedBox(height: 10),
                    // Availability Switch
                    Row(
                      children: [
                        Text(
                          _profile.isAvailable ? 'Available for Hire' : 'Unavailable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _profile.isAvailable ? AppTheme.success : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _profile.isAvailable,
                          activeColor: AppTheme.success,
                          onChanged: (val) {
                            setState(() {
                              _profile.isAvailable = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),

          if (!isDesktop) ...[
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DynamicProfileEdit(profile: _profile),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Profile'),
                ),
                Row(
                  children: [
                    Text(
                      _profile.isAvailable ? 'Available' : 'Busy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _profile.isAvailable ? AppTheme.success : AppTheme.textMuted,
                      ),
                    ),
                    Switch(
                      value: _profile.isAvailable,
                      activeColor: AppTheme.success,
                      onChanged: (val) {
                        setState(() => _profile.isAvailable = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Bio
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _profile.bio,
              style: const TextStyle(fontSize: 14, height: 1.5, color: AppTheme.textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }

  // --- Skills & Certifications Card ---
  Widget _buildSkillsAndCertificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verified Skills & Badges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          if (_profile.skills.isEmpty)
            const Text('No verified skills listed yet.', style: TextStyle(fontSize: 13, color: AppTheme.textMuted))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _profile.skills.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD6D0FF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 13, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        s,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
          const Text(
            'Certifications & Accreditations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_profile.certifications.isEmpty)
            const Text('No certifications uploaded yet.', style: TextStyle(fontSize: 13, color: AppTheme.textMuted))
          else
            ..._profile.certifications.map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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

  // --- Dynamic Profile Fields Card (Preserving & Extending original dynamic schema) ---
  Widget _buildDynamicProfileFieldsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_profile.eventType} Specialization',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DynamicProfileEdit(profile: _profile),
                    ),
                  );
                  setState(() {});
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_profile.details.isEmpty)
            const Text(
              'No event-specific dynamic details set. Click edit to customize for your category.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            )
          else
            ..._profile.details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.value.isNotEmpty ? entry.value : '—',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // --- Work History Timeline ---
  Widget _buildWorkHistoryCard(AppDataState state) {
    final completedWork = state.workforce
        .where((w) =>
            (w.professionalId == _profile.id || w.professionalName == _profile.name) &&
            w.status == 'Completed')
        .toList();

    return Container(
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
            'Verified Work History & Assignments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (completedWork.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No completed work history yet. Verified shifts will automatically populate this timeline upon event completion.',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
              ),
            )
          else
            ...completedWork.map((w) {
              return _historyItem(
                role: w.role,
                event: w.eventName,
                organizer: 'Event Operations Team',
                date: w.date,
                details: 'Shift completed with ${w.totalHours} logged. Verified on-site attendance: ${w.attendanceStatus}.',
              );
            }),
        ],
      ),
    );
  }

  Widget _historyItem({
    required String role,
    required String event,
    required String organizer,
    required String date,
    required String details,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_outline, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      role,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$event • $organizer',
                  style: const TextStyle(fontSize: 13, color: AppTheme.primaryDark, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  details,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Client Reviews Card ---
  Widget _buildClientReviewsCard(AppDataState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Client Ratings & Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RatingStars(rating: _profile.rating, starSize: 16),
            ],
          ),
          const SizedBox(height: 16),
          if (state.reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No client reviews yet. Reviews from event organizers will appear here after shift sign-offs.',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
              ),
            )
          else
            ...state.reviews.map((rev) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceSubtle,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rev.reviewerName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          RatingStars(rating: rev.rating, starSize: 13, showNumber: false),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rev.eventName} • ${rev.date}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"${rev.comment}"',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.4),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
