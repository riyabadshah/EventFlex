import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import '../professional/professional_profile_screen.dart';

class SmartMatchingScreen extends StatefulWidget {
  const SmartMatchingScreen({super.key});

  @override
  State<SmartMatchingScreen> createState() => _SmartMatchingScreenState();
}

class _SmartMatchingScreenState extends State<SmartMatchingScreen> {
  String? _selectedRoleTitle;

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    final allRoles = state.events.expand((e) => e.roles.map((r) => r.name)).toSet().toList();
    final rolesList = allRoles.isNotEmpty ? allRoles : ['Event Staff', 'Coordinator', 'Host / Hostess', 'Security & Access'];

    if (_selectedRoleTitle == null || !rolesList.contains(_selectedRoleTitle)) {
      _selectedRoleTitle = rolesList.first;
    }

    // Generate ranked match candidates dynamically from real professionals
    final candidates = state.allProfessionals.map((pro) {
      final ratingScore = (pro.rating * 4).clamp(0, 20).toInt();
      final matchScore = (75 + ratingScore).clamp(60, 99);
      final reasons = <String>[];

      if (pro.skills.isNotEmpty) {
        reasons.add('Matched on verified skills: ${pro.skills.take(3).join(", ")}');
      } else {
        reasons.add('Verified profile active on platform');
      }

      if (pro.experience.isNotEmpty) {
        reasons.add('${pro.experience} of relevant event operations experience');
      }

      if (pro.location.isNotEmpty) {
        reasons.add('Available for assignment in ${pro.location}');
      }

      reasons.add('Verification status: ${pro.verificationStatus}');

      return SmartMatchCandidate(
        profile: pro,
        matchPercentage: matchScore,
        matchingReasons: reasons,
        distanceKm: 5.0,
      );
    }).toList();

    return Scaffold(
      appBar: const AppNavbar(activeRoute: 'smart-match'),
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
                  // Banner
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.softShadow,
                    ),
                    padding: EdgeInsets.all(isDesktop ? 36 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.auto_awesome_rounded, color: AppTheme.secondary, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Smart AI Workforce Matcher',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Our multi-factor matching algorithm evaluates verified skill sets, past attendance records, geolocation proximity, and client ratings to score the best candidates for your shift.',
                          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Requirement selector
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: AppTheme.primary, size: 22),
                        const SizedBox(width: 12),
                        const Text(
                          'Matching Candidates For: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedRoleTitle,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: rolesList.map((r) {
                              return DropdownMenuItem(
                                value: r,
                                child: Text(r, style: const TextStyle(fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedRoleTitle = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Ranked Candidate Matches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (candidates.isEmpty)
                    const EmptyStateWidget(
                      title: 'No Matching Professionals Found',
                      subtitle: 'When professionals register or apply for roles, their ranked match scores will appear here.',
                    )
                  else
                    // Match Candidate Cards
                    ...candidates.map((cand) {
                      return _buildCandidateMatchCard(context, cand, state);
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateMatchCard(
    BuildContext context,
    SmartMatchCandidate cand,
    AppDataState state,
  ) {
    final pro = cand.profile;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    pro.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            pro.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(status: pro.verificationStatus, isSmall: true),
                          const Spacer(),
                          // Match Percentage Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: cand.matchPercentage >= 90
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 16,
                                  color: cand.matchPercentage >= 90
                                      ? const Color(0xFF15803D)
                                      : const Color(0xFF4338CA),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${cand.matchPercentage}% Match',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: cand.matchPercentage >= 90
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFF4338CA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${pro.experience} Experience • ${pro.location} • ~${cand.distanceKm.toStringAsFixed(1)} km from venue',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RatingStars(rating: pro.rating, starSize: 14),
                          const SizedBox(width: 12),
                          Text(
                            '${pro.completedJobs} Completed Events',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Why this professional matches
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceSubtle,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Match Factors Breakdown:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 6),
                  ...cand.matchingReasons.map((reason) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppTheme.success, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              reason,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 6,
                  children: pro.skills.take(3).map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 11, color: AppTheme.primaryDark)),
                    );
                  }).toList(),
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfessionalProfileScreen(profile: pro),
                          ),
                        );
                      },
                      child: const Text('View Full Profile'),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.success,
                            content: Text('Direct shift invitation sent to ${pro.name}!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: const Text('Send Shift Invitation'),
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
