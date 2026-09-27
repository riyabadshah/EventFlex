import 'package:flutter/material.dart';

void main() {
  runApp(const EventFlexApp());
}

class EventFlexApp extends StatelessWidget {
  const EventFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventFlex',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// EVENT TYPES
// ============================================================

const List<String> eventTypes = [
  'College Event',
  'Sports Event',
  'Corporate Event',
  'Conference / Exhibition',
  'Wedding / Social Event',
  'Concert / Festival',
  'Technical Event',
  'Non-Technical Event',
  'Cultural Event',
  'Other',
];

// ============================================================
// MODELS
// ============================================================

class StaffingRole {
  String name;
  String description;
  int requiredPeople;
  double payment;
  String requiredSkills;

  StaffingRole({
    required this.name,
    required this.description,
    required this.requiredPeople,
    required this.payment,
    required this.requiredSkills,
  });
}

class EventItem {
  String name;
  String description;
  String eventType;
  String date;
  String time;
  String location;
  List<StaffingRole> roles;

  EventItem({
    required this.name,
    required this.description,
    required this.eventType,
    required this.date,
    required this.time,
    required this.location,
    required this.roles,
  });
}

class ProfessionalProfile {
  String name;
  String email;
  String phone;
  String eventType;
  Map<String, String> details;

  ProfessionalProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.eventType,
    required this.details,
  });
}

// ============================================================
// TEMPORARY LOCAL DATA
// ============================================================

final List<EventItem> events = [];

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // LOGO
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B4BFF),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.event_available,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'EventFlex',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Connect. Staff. Manage.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 55),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Continue as',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _roleCard(
                    context,
                    title: 'Organizer',
                    subtitle:
                        'Create events and manage custom staffing roles.',
                    icon: Icons.business_center_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganizerAuthScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _roleCard(
                    context,
                    title: 'Professional',
                    subtitle:
                        'Build your profile and apply for multiple roles.',
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfessionalAuthScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: const Color(0xFFEDEBFF),
                child: Icon(
                  icon,
                  color: const Color(0xFF5B4BFF),
                  size: 29,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORGANIZER AUTH
// ============================================================

class OrganizerAuthScreen extends StatefulWidget {
  const OrganizerAuthScreen({super.key});

  @override
  State<OrganizerAuthScreen> createState() => _OrganizerAuthScreenState();
}

class _OrganizerAuthScreenState extends State<OrganizerAuthScreen> {
  bool login = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  login
                      ? 'Organizer Login'
                      : 'Create Organizer Account',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                if (!login) ...[
                  _field(
                    nameController,
                    'Name',
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                ],

                _field(
                  emailController,
                  'Email',
                  Icons.email_outlined,
                ),

                const SizedBox(height: 14),

                if (!login) ...[
                  _field(
                    phoneController,
                    'Phone',
                    Icons.phone_outlined,
                  ),
                  const SizedBox(height: 14),
                ],

                _field(
                  passwordController,
                  'Password',
                  Icons.lock_outline,
                  obscure: true,
                ),

                const SizedBox(height: 22),

                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrganizerDashboard(),
                      ),
                    );
                  },
                  child: Text(
                    login ? 'Login' : 'Create Account',
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(
                    login
                        ? 'Create a new account'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

// ============================================================
// ORGANIZER DASHBOARD
// ============================================================

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  State<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  String selectedEventType = eventTypes.first;

  @override
  Widget build(BuildContext context) {
    final filteredEvents = events
        .where((event) => event.eventType == selectedEventType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateEventScreen(),
                ),
              );

              setState(() {});
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Organizer Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Event Type',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eventTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: selectedEventType == type,
                onSelected: (_) {
                  setState(() {
                    selectedEventType = type;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 25),

          Text(
            '$selectedEventType Events',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (filteredEvents.isEmpty)
            _emptyCard(
              'No events available for this event type.',
            )
          else
            ...filteredEvents.map(
              (event) => _eventCard(event),
            ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateEventScreen(),
                ),
              );

              setState(() {});
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(EventItem event) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          event.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${event.eventType}\n'
          '${event.date} • ${event.time}\n'
          '${event.location}\n'
          '${event.roles.length} staffing roles',
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrganizerEventDetails(
                event: event,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// CREATE EVENT
// ============================================================

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final eventName = TextEditingController();
  final description = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final location = TextEditingController();

  String selectedEventType = eventTypes.first;

  final List<StaffingRole> staffingRoles = [];

  Future<void> _addRole() async {
    final role = await showDialog<StaffingRole>(
      context: context,
      builder: (_) => const AddRoleDialog(),
    );

    if (role != null) {
      setState(() {
        staffingRoles.add(role);
      });
    }
  }

  Future<void> _editRole(int index) async {
    final role = await showDialog<StaffingRole>(
      context: context,
      builder: (_) => AddRoleDialog(
        existingRole: staffingRoles[index],
      ),
    );

    if (role != null) {
      setState(() {
        staffingRoles[index] = role;
      });
    }
  }

  void _publishEvent() {
    if (eventName.text.trim().isEmpty ||
        date.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill Event Name, Date and Location.',
          ),
        ),
      );
      return;
    }

    events.add(
      EventItem(
        name: eventName.text.trim(),
        description: description.text.trim(),
        eventType: selectedEventType,
        date: date.text.trim(),
        time: time.text.trim(),
        location: location.text.trim(),
        roles: List.from(staffingRoles),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event published successfully.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Select Event Type',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eventTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: selectedEventType == type,
                onSelected: (_) {
                  setState(() {
                    selectedEventType = type;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 25),

          const Text(
            'Event Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _field(eventName, 'Event Name'),
          _field(
            description,
            'Description',
            maxLines: 3,
          ),
          _field(date, 'Date'),
          _field(time, 'Time'),
          _field(location, 'Location'),

          const SizedBox(height: 18),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Staffing Roles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: _addRole,
                icon: const Icon(Icons.add),
                label: const Text('Add Role'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (staffingRoles.isEmpty)
            _emptyCard(
              'Add one or more custom staffing roles.',
            ),

          ...List.generate(
            staffingRoles.length,
            (index) {
              final role = staffingRoles[index];

              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    role.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${role.requiredPeople} people • '
                    '₹${role.payment.toStringAsFixed(0)}\n'
                    'Skills: ${role.requiredSkills}',
                  ),
                  isThreeLine: true,
                  leading: const CircleAvatar(
                    child: Icon(Icons.work_outline),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editRole(index);
                      }

                      if (value == 'delete') {
                        setState(() {
                          staffingRoles.removeAt(index);
                        });
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _publishEvent,
            icon: const Icon(Icons.publish),
            label: const Text('Publish Event'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}

// ============================================================
// ADD / EDIT STAFFING ROLE
// ============================================================

class AddRoleDialog extends StatefulWidget {
  final StaffingRole? existingRole;

  const AddRoleDialog({
    super.key,
    this.existingRole,
  });

  @override
  State<AddRoleDialog> createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {
  late TextEditingController roleName;
  late TextEditingController description;
  late TextEditingController people;
  late TextEditingController payment;
  late TextEditingController skills;

  @override
  void initState() {
    super.initState();

    final role = widget.existingRole;

    roleName = TextEditingController(
      text: role?.name ?? '',
    );

    description = TextEditingController(
      text: role?.description ?? '',
    );

    people = TextEditingController(
      text: role?.requiredPeople.toString() ?? '1',
    );

    payment = TextEditingController(
      text: role?.payment.toStringAsFixed(0) ?? '',
    );

    skills = TextEditingController(
      text: role?.requiredSkills ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existingRole == null
            ? 'Add Staffing Role'
            : 'Edit Staffing Role',
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            _field(roleName, 'Role Name'),

            _field(
              description,
              'Role Description',
              maxLines: 3,
            ),

            _field(
              people,
              'Required People',
              number: true,
            ),

            _field(
              payment,
              'Payment',
              number: true,
            ),

            _field(
              skills,
              'Required Skills',
              maxLines: 3,
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        FilledButton(
          onPressed: () {
            if (roleName.text.trim().isEmpty) {
              return;
            }

            final role = StaffingRole(
              name: roleName.text.trim(),
              description: description.text.trim(),
              requiredPeople:
                  int.tryParse(people.text.trim()) ?? 1,
              payment:
                  double.tryParse(payment.text.trim()) ?? 0,
              requiredSkills: skills.text.trim(),
            );

            Navigator.pop(context, role);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType:
            number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}

// ============================================================
// ORGANIZER EVENT DETAILS
// ============================================================

class OrganizerEventDetails extends StatelessWidget {
  final EventItem event;

  const OrganizerEventDetails({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            event.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Chip(
            label: Text(event.eventType),
          ),

          const SizedBox(height: 15),

          Text(event.description),

          const SizedBox(height: 18),

          Text('Date: ${event.date}'),
          Text('Time: ${event.time}'),
          Text('Location: ${event.location}'),

          const SizedBox(height: 25),

          const Text(
            'Staffing Roles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...event.roles.map(
            (role) => Card(
              elevation: 0,
              child: ListTile(
                title: Text(
                  role.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${role.description}\n'
                  'Required People: ${role.requiredPeople}\n'
                  'Payment: ₹${role.payment.toStringAsFixed(0)}\n'
                  'Skills: ${role.requiredSkills}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFESSIONAL AUTH
// ============================================================

class ProfessionalAuthScreen extends StatefulWidget {
  const ProfessionalAuthScreen({super.key});

  @override
  State<ProfessionalAuthScreen> createState() =>
      _ProfessionalAuthScreenState();
}

class _ProfessionalAuthScreenState
    extends State<ProfessionalAuthScreen> {
  bool login = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional'),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  login
                      ? 'Professional Login'
                      : 'Create Professional Account',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                if (!login) ...[
                  _field(
                    nameController,
                    'Name',
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                ],

                _field(
                  emailController,
                  'Email',
                  Icons.email_outlined,
                ),

                const SizedBox(height: 14),

                if (!login) ...[
                  _field(
                    phoneController,
                    'Phone',
                    Icons.phone_outlined,
                  ),
                  const SizedBox(height: 14),
                ],

                _field(
                  passwordController,
                  'Password',
                  Icons.lock_outline,
                  obscure: true,
                ),

                const SizedBox(height: 22),

                FilledButton(
                  onPressed: () {
                    final profile = ProfessionalProfile(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      eventType: eventTypes.first,
                      details: {},
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfessionalDashboard(
                          profile: profile,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    login ? 'Login' : 'Create Account',
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(
                    login
                        ? 'Create a new account'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

// ============================================================
// PROFESSIONAL DASHBOARD
// ============================================================

class ProfessionalDashboard extends StatefulWidget {
  final ProfessionalProfile profile;

  const ProfessionalDashboard({
    super.key,
    required this.profile,
  });

  @override
  State<ProfessionalDashboard> createState() =>
      _ProfessionalDashboardState();
}

class _ProfessionalDashboardState
    extends State<ProfessionalDashboard> {
  late String selectedEventType;

  @override
  void initState() {
    super.initState();

    selectedEventType = widget.profile.eventType;
  }

  Future<void> _selectEventType(String type) async {
    setState(() {
      selectedEventType = type;
      widget.profile.eventType = type;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DynamicProfessionalProfile(
          profile: widget.profile,
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final matchingEvents = events
        .where(
          (event) => event.eventType == selectedEventType,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DynamicProfessionalProfile(
                    profile: widget.profile,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Professional Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Event Type',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eventTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: selectedEventType == type,
                onSelected: (_) {
                  _selectEventType(type);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DynamicProfessionalProfile(
                    profile: widget.profile,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text(
              'Complete / Edit Professional Profile',
            ),
          ),

          const SizedBox(height: 25),

          Text(
            'Matching $selectedEventType Events',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (matchingEvents.isEmpty)
            _emptyCard(
              'No matching published events available.',
            )
          else
            ...matchingEvents.map(
              (event) => Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    event.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${event.eventType}\n'
                    '${event.date} • ${event.time}\n'
                    '${event.location}\n'
                    '${event.roles.length} available roles',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfessionalEventDetails(
                          event: event,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// DYNAMIC PROFESSIONAL PROFILE
// ============================================================

class DynamicProfessionalProfile extends StatefulWidget {
  final ProfessionalProfile profile;

  const DynamicProfessionalProfile({
    super.key,
    required this.profile,
  });

  @override
  State<DynamicProfessionalProfile> createState() =>
      _DynamicProfessionalProfileState();
}

class _DynamicProfessionalProfileState
    extends State<DynamicProfessionalProfile> {
  late String selectedType;

  final Map<String, TextEditingController> controllers = {};

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

      case 'Sports Event':
        return [
          'Sports Skills',
          'Sport / Specialization',
          'Experience',
          'Achievements',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Cultural Event':
        return [
          'Creative / Performance Skills',
          'Specialization',
          'Experience',
          'Achievements',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Corporate Event':
        return [
          'Professional Skills',
          'Specialization',
          'Experience',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Conference / Exhibition':
        return [
          'Professional Skills',
          'Event Experience',
          'Specialization',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Wedding / Social Event':
        return [
          'Event Skills',
          'Specialization',
          'Experience',
          'Services / Expertise',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Concert / Festival':
        return [
          'Event Skills',
          'Performance / Production Skills',
          'Experience',
          'Specialization',
          'Location',
          'Profile / Portfolio',
        ];

      case 'College Event':
        return [
          'Skills',
          'Experience',
          'Specialization',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      case 'Non-Technical Event':
        return [
          'Skills',
          'Experience',
          'Specialization',
          'Certifications',
          'Location',
          'Profile / Portfolio',
        ];

      default:
        return [
          'Skills',
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

    _createControllers();
  }

  void _createControllers() {
    for (final controller in controllers.values) {
      controller.dispose();
    }

    controllers.clear();

    for (final field in fieldsForEventType(selectedType)) {
      controllers[field] = TextEditingController(
        text: widget.profile.details[field] ?? '',
      );
    }
  }

  void _saveProfile() {
    widget.profile.eventType = selectedType;

    widget.profile.details.clear();

    for (final entry in controllers.entries) {
      widget.profile.details[entry.key] =
          entry.value.text.trim();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Professional profile saved.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fields = fieldsForEventType(selectedType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Profile'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Event Type',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: const InputDecoration(
              labelText: 'Select Event Type',
            ),
            items: eventTypes.map(
              (type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              },
            ).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedType = value;

                widget.profile.eventType =
                    selectedType;

                _createControllers();
              });
            },
          ),

          const SizedBox(height: 22),

          Text(
            'Profile Details',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...fields.map(
            (field) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: TextField(
                  controller: controllers[field],
                  maxLines:
                      field.contains('Skills') ||
                              field.contains('Projects') ||
                              field.contains('Portfolio') ||
                              field.contains('Achievements')
                          ? 3
                          : 1,
                  decoration: InputDecoration(
                    labelText: field,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          FilledButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Profile'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
}

// ============================================================
// PROFESSIONAL EVENT DETAILS
// ============================================================

class ProfessionalEventDetails extends StatefulWidget {
  final EventItem event;

  const ProfessionalEventDetails({
    super.key,
    required this.event,
  });

  @override
  State<ProfessionalEventDetails> createState() =>
      _ProfessionalEventDetailsState();
}

class _ProfessionalEventDetailsState
    extends State<ProfessionalEventDetails> {
  final Set<int> selectedRoles = {};

  void _applyForRoles() {
    if (selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Select at least one staffing role.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Application submitted for '
          '${selectedRoles.length} selected role(s).',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            event.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Chip(
            label: Text(event.eventType),
          ),

          const SizedBox(height: 15),

          Text(event.description),

          const SizedBox(height: 18),

          Text('Date: ${event.date}'),
          Text('Time: ${event.time}'),
          Text('Location: ${event.location}'),

          const SizedBox(height: 25),

          const Text(
            'Available Staffing Roles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...List.generate(
            event.roles.length,
            (index) {
              final role = event.roles[index];

              final selected =
                  selectedRoles.contains(index);

              return Card(
                elevation: 0,
                color: selected
                    ? const Color(0xFFEDEBFF)
                    : Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: CheckboxListTile(
                  value: selected,
                  onChanged: (_) {
                    setState(() {
                      if (selected) {
                        selectedRoles.remove(index);
                      } else {
                        selectedRoles.add(index);
                      }
                    });
                  },
                  title: Text(
                    role.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${role.description}\n'
                    'Required People: ${role.requiredPeople}\n'
                    'Payment: ₹${role.payment.toStringAsFixed(0)}\n'
                    'Required Skills: ${role.requiredSkills}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          FilledButton.icon(
            onPressed: _applyForRoles,
            icon: const Icon(Icons.send_outlined),
            label: const Text(
              'Apply for Selected Roles',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMMON WIDGETS
// ============================================================

Widget _emptyCard(String text) {
  return Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
    ),
  );
}