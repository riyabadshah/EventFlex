import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class PostRequirementScreen extends StatefulWidget {
  const PostRequirementScreen({super.key});

  @override
  State<PostRequirementScreen> createState() => _PostRequirementScreenState();
}

class _PostRequirementScreenState extends State<PostRequirementScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEventId;
  final _roleNameController = TextEditingController();
  final _descController = TextEditingController();
  final _peopleController = TextEditingController(text: '3');
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController(text: '1+ years');
  final _dateController = TextEditingController();
  final _hoursController = TextEditingController(text: '8:00 AM - 5:00 PM');
  final _paymentController = TextEditingController(text: '3500');
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final events = AppDataState.instance.events;
    if (events.isNotEmpty) {
      _selectedEventId = events.first.id;
      _dateController.text = events.first.date;
      _locationController.text = events.first.location;
    }
  }

  void _applyRolePreset(String roleName) {
    setState(() {
      _roleNameController.text = roleName;
      switch (roleName) {
        case 'Host/Hostess':
          _descController.text =
              'Welcome VIP delegates, assist with registration, keynote speaker coordination, and distribute schedules.';
          _skillsController.text = 'VIP Hospitality, Fluent English, Poise, Etiquette';
          _paymentController.text = '4000';
          break;
        case 'Event Manager':
          _descController.text =
              'Oversee floor operations, stage cues, vendor deliveries, and supervise on-site volunteer crew.';
          _skillsController.text = 'Operations, Team Leadership, Crisis Management';
          _paymentController.text = '6500';
          break;
        case 'Security Staff':
          _descController.text =
              'Crowd management at main gates, metal detector screening, and perimeter badge checking.';
          _skillsController.text = 'Crowd Control, Access Screening, Physical Fitness';
          _paymentController.text = '2800';
          break;
        case 'Photographer':
          _descController.text =
              'Full coverage of keynote sessions, delegate candid moments, sponsor booths, and evening gala.';
          _skillsController.text = 'DSLR/Mirrorless, Flash Photography, Rapid Editing';
          _paymentController.text = '7000';
          break;
        case 'Technician':
          _descController.text =
              'Manage audio visual inputs, wireless microphones, LED walls, and presentation clickers.';
          _skillsController.text = 'Audio Mixer, HDMI/SDI Switches, Troubleshooting';
          _paymentController.text = '5000';
          break;
        case 'Registration Staff':
          _descController.text =
              'Operate self check-in kiosks, issue RFID wristbands, badge printing, and answer delegate FAQs.';
          _skillsController.text = 'Tech Savvy, Punctual, Good Communication';
          _paymentController.text = '3200';
          break;
        default:
          _descController.text = 'Assist with event logistics, stage setup, and guest inquiries.';
          _skillsController.text = 'Communication, Punctual, Team Player';
          _paymentController.text = '3000';
      }
    });
  }

  void _publishRequirement() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event.')),
      );
      return;
    }

    final state = AppDataState.instance;
    final event = state.events.firstWhere((e) => e.id == _selectedEventId);

    final newRole = StaffingRole(
      name: _roleNameController.text.trim(),
      description: _descController.text.trim(),
      requiredPeople: int.tryParse(_peopleController.text.trim()) ?? 1,
      payment: double.tryParse(_paymentController.text.trim()) ?? 3000,
      requiredSkills: _skillsController.text.trim(),
      experienceRequired: _experienceController.text.trim(),
      workingHours: _hoursController.text.trim(),
      date: _dateController.text.trim().isNotEmpty ? _dateController.text.trim() : event.date,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : event.location,
      eventId: event.id,
      eventName: event.name,
      organizerName: event.organizerName,
    );

    state.addStaffingRoleToEvent(event.id, newRole);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.success,
        content: Text('Staffing requirement "${newRole.name}" published to Marketplace!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Staffing Requirement'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: AppTheme.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Post Staffing Position',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Define role requirements, required headcount, skills and daily shift rate.',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Select Event Dropdown
                      const Text('Associate with Event', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedEventId,
                        items: state.events.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text('${e.name} (${e.date})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedEventId = val;
                            if (val != null) {
                              final ev = state.events.firstWhere((e) => e.id == val);
                              _dateController.text = ev.date;
                              _locationController.text = ev.location;
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Quick Role Preset Chips
                      const Text('Quick Role Presets', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: commonStaffingRoles.map((role) {
                          return ActionChip(
                            label: Text(role),
                            avatar: const Icon(Icons.flash_on, size: 14, color: AppTheme.primary),
                            onPressed: () => _applyRolePreset(role),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _roleNameController,
                        decoration: const InputDecoration(
                          labelText: 'Role Name',
                          hintText: 'e.g. Lead Registration Coordinator',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Role name is required' : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Job Description & Duties',
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _peopleController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Number of Workers',
                                prefixIcon: Icon(Icons.people_outline),
                              ),
                              validator: (v) => (v == null || int.tryParse(v.trim()) == null)
                                  ? 'Enter valid number'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _paymentController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Daily Payment (₹)',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                              validator: (v) => (v == null || double.tryParse(v.trim()) == null)
                                  ? 'Enter valid amount'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _skillsController,
                        decoration: const InputDecoration(
                          labelText: 'Required Skills (comma separated)',
                          hintText: 'Guest Relations, Fluency, Punctual',
                          prefixIcon: Icon(Icons.bolt_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Skills are required' : null,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _experienceController,
                              decoration: const InputDecoration(
                                labelText: 'Experience Required',
                                prefixIcon: Icon(Icons.timeline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _hoursController,
                              decoration: const InputDecoration(
                                labelText: 'Working Hours',
                                prefixIcon: Icon(Icons.schedule_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date (YYYY-MM-DD)',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                labelText: 'Specific Location / Hall',
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      FilledButton.icon(
                        onPressed: _publishRequirement,
                        icon: const Icon(Icons.publish_rounded),
                        label: const Text('Publish Requirement to Marketplace'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
