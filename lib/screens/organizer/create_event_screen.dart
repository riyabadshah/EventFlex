import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _attendanceController = TextEditingController();
  final _budgetController = TextEditingController();
  final _contactController = TextEditingController();

  String _selectedEventType = 'Conferences';

  @override
  void initState() {
    super.initState();
    _dateController.text = '2026-10-25';
    _startTimeController.text = '09:00 AM';
    _endTimeController.text = '06:00 PM';
    _attendanceController.text = '1,500 Attendees';
    _budgetController.text = '120000';
    _contactController.text = 'events@apexproductions.com';
  }

  void _submitEvent() {
    if (!_formKey.currentState!.validate()) return;

    final state = AppDataState.instance;

    final newEvent = EventItem(
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      eventType: _selectedEventType,
      date: _dateController.text.trim(),
      time: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
      location: _locationController.text.trim(),
      expectedAttendance: _attendanceController.text.trim(),
      budget: double.tryParse(_budgetController.text.trim()) ?? 50000,
      contactInfo: _contactController.text.trim(),
      organizerName: state.currentOrganizer.companyName,
      roles: [],
    );

    state.addEvent(newEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.success,
        content: Text('Event "${newEvent.name}" published successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
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
                        'Event Specifications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Provide comprehensive event details. You can attach staffing requirements immediately after publishing.',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Event Type Dropdown / Chips
                      const Text(
                        'Event Category',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedEventType,
                        items: eventTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedEventType = val);
                        },
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Event Name',
                          hintText: 'e.g. Asia Fintech Summit 2026',
                          prefixIcon: Icon(Icons.event_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Event name is required'
                            : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Event Description & Objectives',
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Description is required'
                            : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Venue & City Location',
                          hintText: 'e.g. Grand Hyatt / BKC Mumbai',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Location is required'
                            : null,
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
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Date is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _attendanceController,
                              decoration: const InputDecoration(
                                labelText: 'Expected Attendees',
                                prefixIcon: Icon(Icons.people_outline),
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
                              controller: _startTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Start Time',
                                prefixIcon: Icon(Icons.schedule_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _endTimeController,
                              decoration: const InputDecoration(
                                labelText: 'End Time',
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
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Total Staffing Budget (₹)',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _contactController,
                              decoration: const InputDecoration(
                                labelText: 'Contact Info / Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      FilledButton.icon(
                        onPressed: _submitEvent,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Publish Event to GoWow'),
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
