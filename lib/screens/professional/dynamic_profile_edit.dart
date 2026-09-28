import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class DynamicProfileEdit extends StatefulWidget {
  final ProfessionalProfile profile;

  const DynamicProfileEdit({
    super.key,
    required this.profile,
  });

  @override
  State<DynamicProfileEdit> createState() => _DynamicProfileEditState();
}

class _DynamicProfileEditState extends State<DynamicProfileEdit> {
  late String selectedType;
  late TextEditingController nameController;
  late TextEditingController experienceController;
  late TextEditingController locationController;
  late TextEditingController bioController;
  late TextEditingController skillsController;

  final Map<String, TextEditingController> dynamicControllers = {};

  List<String> fieldsForEventType(String type) {
    switch (type) {
      case 'Technical Event':
        return [
          'Technical Skills',
          'Programming Languages',
          'Frameworks',
          'Experience',
          'Projects',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Sports Events':
        return [
          'Sports Skills',
          'Sport / Specialization',
          'Experience',
          'Achievements',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Cultural Events':
        return [
          'Creative / Performance Skills',
          'Specialization',
          'Experience',
          'Achievements',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Corporate Events':
        return [
          'Professional Skills',
          'Specialization',
          'Experience',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Conferences':
        return [
          'Professional Skills',
          'Event Experience',
          'Specialization',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Weddings':
        return [
          'Event Skills',
          'Specialization',
          'Experience',
          'Services / Expertise',
          'Location',
          'Profile / Portfolio',
        ];
      case 'Concerts':
        return [
          'Event Skills',
          'Performance / Production Skills',
          'Experience',
          'Specialization',
          'Location',
          'Profile / Portfolio',
        ];
      default:
        return [
          'Core Skills',
          'Experience',
          'Specialization',
          'Location',
          'Profile / Portfolio',
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    selectedType = widget.profile.eventType;

    nameController = TextEditingController(text: widget.profile.name);
    experienceController = TextEditingController(text: widget.profile.experience);
    locationController = TextEditingController(text: widget.profile.location);
    bioController = TextEditingController(text: widget.profile.bio);
    skillsController = TextEditingController(text: widget.profile.skills.join(', '));

    _createControllers();
  }

  void _createControllers() {
    for (final controller in dynamicControllers.values) {
      controller.dispose();
    }
    dynamicControllers.clear();

    for (final field in fieldsForEventType(selectedType)) {
      dynamicControllers[field] = TextEditingController(
        text: widget.profile.details[field] ?? '',
      );
    }
  }

  void _saveProfile() {
    widget.profile.name = nameController.text.trim();
    widget.profile.experience = experienceController.text.trim();
    widget.profile.location = locationController.text.trim();
    widget.profile.bio = bioController.text.trim();
    widget.profile.eventType = selectedType;

    final parsedSkills = skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parsedSkills.isNotEmpty) {
      widget.profile.skills = parsedSkills;
    }

    widget.profile.details.clear();
    for (final entry in dynamicControllers.entries) {
      widget.profile.details[entry.key] = entry.value.text.trim();
    }

    // Boost profile completion
    widget.profile.profileCompletion = 95;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.success,
        content: Text('Professional profile and dynamic details saved successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    experienceController.dispose();
    locationController.dispose();
    bioController.dispose();
    skillsController.dispose();
    for (final c in dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = fieldsForEventType(selectedType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Professional Profile'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Profile Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Keep your credentials updated to receive high-paying event recommendations.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: experienceController,
                            decoration: const InputDecoration(
                              labelText: 'Experience (e.g. 3 years)',
                              prefixIcon: Icon(Icons.timeline_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location / City',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Key Skills (comma separated)',
                        prefixIcon: Icon(Icons.bolt_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: bioController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Professional Bio',
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    const Text(
                      'Event Type & Domain Specialization',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dynamic fields update automatically based on your event category.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: eventTypes.contains(selectedType) ? selectedType : eventTypes.first,
                      decoration: const InputDecoration(
                        labelText: 'Select Primary Event Category',
                      ),
                      items: eventTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedType = value;
                          _createControllers();
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Dynamic Fields
                    ...fields.map((field) {
                      final isMulti = field.contains('Skills') ||
                          field.contains('Projects') ||
                          field.contains('Portfolio') ||
                          field.contains('Achievements');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TextField(
                          controller: dynamicControllers[field],
                          maxLines: isMulti ? 2 : 1,
                          decoration: InputDecoration(
                            labelText: field,
                            alignLabelWithHint: isMulti,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Save Profile & Details'),
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
    );
  }
}
