import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';
import 'job_details_screen.dart';

class JobDiscoveryScreen extends StatefulWidget {
  const JobDiscoveryScreen({super.key});

  @override
  State<JobDiscoveryScreen> createState() => _JobDiscoveryScreenState();
}

class _JobDiscoveryScreenState extends State<JobDiscoveryScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Locations';
  String _selectedRole = 'All Roles';
  double _minPayment = 0;
  String _sortBy = 'Highest Pay';

  final List<String> _locations = [
    'All Locations',
    'BKC, Mumbai',
    'Mahalaxmi, Mumbai',
    'Bengaluru',
    'Hyderabad',
    'Delhi NCR',
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        // Build flat list of all open positions
        final List<Map<String, dynamic>> allJobs = [];
        for (var ev in state.events) {
          for (var r in ev.roles) {
            allJobs.add({'role': r, 'event': ev});
          }
        }

        // Apply filters
        final filteredJobs = allJobs.where((item) {
          final StaffingRole role = item['role'];
          final EventItem event = item['event'];

          final query = _searchController.text.toLowerCase().trim();
          if (query.isNotEmpty) {
            final matchRole = role.name.toLowerCase().contains(query);
            final matchEvent = event.name.toLowerCase().contains(query);
            final matchSkills = role.requiredSkills.toLowerCase().contains(query);
            final matchOrg = event.organizerName.toLowerCase().contains(query);
            if (!matchRole && !matchEvent && !matchSkills && !matchOrg) return false;
          }

          if (_selectedCategory != 'All' && event.eventType != _selectedCategory) {
            return false;
          }

          if (_selectedLocation != 'All Locations' &&
              !event.location.toLowerCase().contains(_selectedLocation.toLowerCase()) &&
              !role.location.toLowerCase().contains(_selectedLocation.toLowerCase())) {
            return false;
          }

          if (_selectedRole != 'All Roles' &&
              !role.name.toLowerCase().contains(_selectedRole.toLowerCase())) {
            return false;
          }

          if (role.payment < _minPayment) {
            return false;
          }

          return true;
        }).toList();

        // Sort
        if (_sortBy == 'Highest Pay') {
          filteredJobs.sort((a, b) =>
              (b['role'] as StaffingRole).payment.compareTo((a['role'] as StaffingRole).payment));
        } else if (_sortBy == 'Required Openings') {
          filteredJobs.sort((a, b) =>
              (b['role'] as StaffingRole).requiredPeople.compareTo((a['role'] as StaffingRole).requiredPeople));
        }

        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'jobs'),
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
                      // Header & Search Banner
                      _buildHeaderBanner(context, isDesktop),

                      const SizedBox(height: 28),

                      // Desktop: Filter Sidebar + Job Feed | Mobile: Filter Row + Feed
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 280,
                                  child: _buildFilterSidebar(context),
                                ),
                                const SizedBox(width: 28),
                                Expanded(
                                  child: _buildJobList(context, filteredJobs, state),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildFilterSidebar(context),
                                const SizedBox(height: 20),
                                _buildJobList(context, filteredJobs, state),
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

  // --- Header & Search Banner ---
  Widget _buildHeaderBanner(BuildContext context, bool isDesktop) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Event Staffing Marketplace',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              StatusBadge(status: 'Verified Escrow Payouts'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore high-paying on-demand staffing roles across conferences, weddings, sports, and festivals.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppTheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search event jobs by title, skills (e.g. Hostess, Registration, A/V)...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Sidebar ---
  Widget _buildFilterSidebar(BuildContext context) {
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
              const Text(
                'Filter Jobs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedCategory = 'All';
                    _selectedLocation = 'All Locations';
                    _selectedRole = 'All Roles';
                    _minPayment = 0;
                  });
                },
                child: const Text('Reset', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location Dropdown
          const Text('Location', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            isExpanded: true,
            items: _locations.map((loc) {
              return DropdownMenuItem(value: loc, child: Text(loc, style: const TextStyle(fontSize: 13)));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedLocation = val);
            },
          ),

          const SizedBox(height: 18),

          // Event Category
          const Text('Event Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            isExpanded: true,
            items: ['All', ...eventTypes].map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),

          const SizedBox(height: 18),

          // Role Filter
          const Text('Common Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            isExpanded: true,
            items: ['All Roles', ...commonStaffingRoles].map((r) {
              return DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13)));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedRole = val);
            },
          ),

          const SizedBox(height: 20),

          // Minimum Payment Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Min Daily Pay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text('₹${_minPayment.toStringAsFixed(0)}+', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ],
          ),
          Slider(
            value: _minPayment,
            min: 0,
            max: 5000,
            divisions: 10,
            activeColor: AppTheme.primary,
            onChanged: (val) => setState(() => _minPayment = val),
          ),
        ],
      ),
    );
  }

  // --- Job Cards List ---
  Widget _buildJobList(
    BuildContext context,
    List<Map<String, dynamic>> jobs,
    AppDataState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort & Result Count Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${jobs.length} Positions Available',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text('Sort by: ', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  items: const [
                    DropdownMenuItem(value: 'Highest Pay', child: Text('Highest Pay')),
                    DropdownMenuItem(value: 'Required Openings', child: Text('Required Openings')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _sortBy = val);
                  },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        if (jobs.isEmpty)
          const EmptyStateWidget(
            title: 'No Matching Jobs Found',
            subtitle: 'Try changing your search keywords or resetting filter parameters.',
          )
        else
          ...jobs.map((item) {
            final StaffingRole role = item['role'];
            final EventItem event = item['event'];

            final hasApplied = state.applications.any(
              (a) => a.jobId == role.id && a.professionalId == state.currentProfessional.id,
            );

            final app = hasApplied
                ? state.applications.firstWhere((a) =>
                    a.jobId == role.id && a.professionalId == state.currentProfessional.id)
                : null;

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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    role.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.verified, color: AppTheme.primary, size: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event.name} • ${event.organizerName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '₹${role.payment.toStringAsFixed(0)} / day',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      role.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.5),
                    ),

                    const SizedBox(height: 16),

                    // Metadata chips
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _metaChip(Icons.location_on_outlined, role.location.isNotEmpty ? role.location : event.location),
                        _metaChip(Icons.calendar_today_outlined, role.date.isNotEmpty ? role.date : event.date),
                        _metaChip(Icons.schedule_rounded, role.workingHours),
                        _metaChip(Icons.people_outline, '${role.requiredPeople} Needed (${role.hiredCount} Hired)'),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skills Chips
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: role.requiredSkills
                                .split(',')
                                .take(3)
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
                        ),

                        // Action Buttons
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
                              child: const Text('View Details'),
                            ),
                            const SizedBox(width: 10),
                            if (hasApplied)
                              StatusBadge(status: app?.status ?? 'Applied')
                            else
                              FilledButton(
                                onPressed: () {
                                  state.applyForJob(role, event);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTheme.success,
                                      content: Text('Applied for ${role.name}!'),
                                    ),
                                  );
                                },
                                child: const Text('Apply Now'),
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

  Widget _metaChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }
}
