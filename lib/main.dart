
import 'package:flutter/material.dart';
import 'services/api_service.dart';


void main() {
  runApp(const EventFlexApp());
}

// ============================================================
// EVENTFLEX - Hackathon-ready Flutter UI prototype
// Material 3 • Light theme • Responsive • No external packages
// Backend/API can be connected later without changing the UI flow.
// ============================================================

class EventFlexApp extends StatelessWidget {
  const EventFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventFlex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BFF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF5B4BFF),
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

enum UserType { organizer, professional }

class StaffingRole {
  String name;
  String description;
  int people;
  double payment;
  String skills;

  StaffingRole({
    required this.name,
    required this.description,
    required this.people,
    required this.payment,
    required this.skills,
  });
}

class EventModel {
  String name;
  String type;
  String description;
  DateTime date;
  TimeOfDay time;
  String location;
  List<StaffingRole> roles;
  int applicants;

  EventModel({
    required this.name,
    required this.type,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.roles,
    this.applicants = 0,
  });
}

class ApplicationModel {
  final EventModel event;
  final StaffingRole role;
  String status;

  ApplicationModel({
    required this.event,
    required this.role,
    this.status = 'Pending',
  });
}

// ============================================================
// DEMO DATA
// ============================================================

final List<EventModel> demoEvents = [
  EventModel(
    name: 'College Tech Fest',
    type: 'College Event',
    description:
        'Annual technology festival with competitions, workshops and student activities.',
    date: DateTime(2026, 10, 15),
    time: const TimeOfDay(hour: 10, minute: 0),
    location: 'Bhopal',
    applicants: 18,
    roles: [
      StaffingRole(
        name: 'Event Coordinator',
        description: 'Manage event activities and coordinate volunteers.',
        people: 5,
        payment: 1000,
        skills: 'Communication, Management',
      ),
      StaffingRole(
        name: 'Registration Manager',
        description: 'Handle participant registration and help desk.',
        people: 3,
        payment: 800,
        skills: 'Communication, Computer Skills',
      ),
      StaffingRole(
        name: 'Technical Support',
        description: 'Handle technical setup and on-ground support.',
        people: 4,
        payment: 1200,
        skills: 'Technical Knowledge',
      ),
    ],
  ),
  EventModel(
    name: 'Inter College Sports Meet',
    type: 'Sports Event',
    description:
        'Multi-college sports tournament requiring on-ground coordination staff.',
    date: DateTime(2026, 11, 5),
    time: const TimeOfDay(hour: 9, minute: 0),
    location: 'Indore',
    applicants: 11,
    roles: [
      StaffingRole(
        name: 'Ground Coordinator',
        description: 'Coordinate players, schedules and ground activities.',
        people: 6,
        payment: 1100,
        skills: 'Team Management, Coordination',
      ),
      StaffingRole(
        name: 'Registration Desk',
        description: 'Manage team registration and participant records.',
        people: 2,
        payment: 700,
        skills: 'Communication',
      ),
    ],
  ),
];

final List<ApplicationModel> demoApplications = [
  ApplicationModel(
    event: demoEvents[0],
    role: demoEvents[0].roles[0],
    status: 'Accepted',
  ),
  ApplicationModel(
    event: demoEvents[1],
    role: demoEvents[1].roles[0],
    status: 'Pending',
  ),
];

// ============================================================
// COMMON WIDGETS
// ============================================================

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C5CE7), Color(0xFF5B4BFF)],
        ),
      ),
      child: Icon(Icons.event_available_rounded,
          color: Colors.white, size: size * .55),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        const AppLogo(size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5B4BFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF5B4BFF)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final bool organizerMode;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.organizerMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4BFF).withOpacity(.09),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    event.type,
                    style: const TextStyle(
                      color: Color(0xFF5143D8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                _Info(icon: Icons.calendar_month_rounded,
                    text: formatDate(event.date)),
                _Info(icon: Icons.location_on_outlined, text: event.location),
                _Info(
                  icon: Icons.people_outline_rounded,
                  text: organizerMode
                      ? '${event.applicants} applicants'
                      : '${event.roles.length} roles',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Info({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }
}

class RoleCard extends StatelessWidget {
  final StaffingRole role;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoleCard({
    super.key,
    required this.role,
    this.selected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF5B4BFF).withOpacity(.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF5B4BFF)
                : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (onTap != null)
                  Checkbox(
                    value: selected,
                    onChanged: (_) => onTap?.call(),
                    activeColor: const Color(0xFF5B4BFF),
                  ),
                Expanded(
                  child: Text(
                    role.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 19),
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 19),
                  ),
              ],
            ),
            Text(
              role.description,
              style: TextStyle(color: Colors.grey.shade600, height: 1.35),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _Info(
                  icon: Icons.people_outline_rounded,
                  text: '${role.people} people',
                ),
                _Info(
                  icon: Icons.currency_rupee_rounded,
                  text: '${role.payment.toStringAsFixed(0)} / person',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              role.skills,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME
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
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  const AppLogo(size: 76),
                  const SizedBox(height: 18),
                  const Text(
                    'EventFlex',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Smart event staffing, from people to performance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Find the right people.\nBuild better events.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _EntryCard(
                    icon: Icons.business_center_rounded,
                    title: "I'm an Organizer",
                    subtitle: 'Create events, add custom roles and manage staff.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AuthScreen(userType: UserType.organizer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _EntryCard(
                    icon: Icons.person_search_rounded,
                    title: "I'm a Professional",
                    subtitle: 'Discover gigs, apply for roles and build your profile.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(
                          userType: UserType.professional,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Verified talent • Flexible staffing • Transparent workflow',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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
}

class _EntryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF5B4BFF).withOpacity(.09),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: const Color(0xFF5B4BFF), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.grey.shade600, height: 1.35)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 17),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AUTH
// ============================================================

class AuthScreen extends StatefulWidget {
  final UserType userType;

  const AuthScreen({super.key, required this.userType});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscure = true;

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> continueToApp() async {
  try {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      showInfo(context, 'Please enter email and password.');
      return;
    }

    if (!isLogin && name.text.trim().isEmpty) {
      showInfo(context, 'Please enter your full name.');
      return;
    }

    if (!isLogin && phone.text.trim().isEmpty) {
      showInfo(context, 'Please enter your phone number.');
      return;
    }

    final role = widget.userType == UserType.organizer
        ? 'organizer'
        : 'professional';

    if (isLogin) {
      // LOGIN
      await ApiService.login(
        email: email.text.trim(),
        password: password.text,
      );
    } else {
      // SIGNUP
      await ApiService.register(
        name: name.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        password: password.text,
        role: role,
      );
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => widget.userType == UserType.organizer
            ? const OrganizerShell()
            : const ProfessionalShell(),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    showInfo(
      context,
      e.toString().replaceFirst('Exception: ', ''),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final label =
        widget.userType == UserType.organizer ? 'Organizer' : 'Professional';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppLogo(size: 38),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogin ? 'Welcome back 👋' : 'Create your account',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLogin
                        ? 'Login to your EventFlex $label account.'
                        : 'Join EventFlex as a $label.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),
                  if (!isLogin) ...[
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  if (isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showInfo(context, 'Password reset flow can be connected to the backend/API.'),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: isLogin ? 'Login' : 'Create Account',
                    onPressed: continueToApp,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? 'New to EventFlex? Create Account'
                            : 'Already have an account? Login',
                      ),
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
}

// ============================================================
// ORGANIZER SHELL
// ============================================================

class OrganizerShell extends StatefulWidget {
  const OrganizerShell({super.key});

  @override
  State<OrganizerShell> createState() => _OrganizerShellState();
}

class _OrganizerShellState extends State<OrganizerShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      OrganizerDashboard(
        onCreate: openCreateEvent,
        onManage: (event) => openEventManagement(event),
      ),
      OrganizerEvents(
        onCreate: openCreateEvent,
        onManage: openEventManagement,
      ),
      const OrganizerApplicants(),
      const OrganizerProfile(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Applicants',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> openCreateEvent() async {
    final result = await Navigator.push<EventModel>(
      context,
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );

    if (result != null) {
      setState(() {
        demoEvents.insert(0, result);
      });
    }
  }

  void openEventManagement(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrganizerEventManagement(event: event),
      ),
    );
  }
}

class OrganizerDashboard extends StatelessWidget {
  final VoidCallback onCreate;
  final void Function(EventModel event) onManage;

  const OrganizerDashboard({
    super.key,
    required this.onCreate,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Good Evening, Organizer 👋',
                  subtitle: 'Manage your events and staffing.',
                ),
                const SizedBox(height: 26),
                Row(
                  children: const [
                    StatCard(
                      value: '3',
                      label: 'Events',
                      icon: Icons.event_available_rounded,
                    ),
                    SizedBox(width: 10),
                    StatCard(
                      value: '29',
                      label: 'Applicants',
                      icon: Icons.people_alt_outlined,
                    ),
                    SizedBox(width: 10),
                    StatCard(
                      value: '₹24K',
                      label: 'Spending',
                      icon: Icons.currency_rupee_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                PrimaryButton(
                  text: 'Create New Event',
                  icon: Icons.add_rounded,
                  onPressed: onCreate,
                ),
                const SizedBox(height: 28),
                const SectionTitle(title: 'My Events'),
                const SizedBox(height: 12),
                ...demoEvents.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: event,
                      organizerMode: true,
                      onTap: () => onManage(event),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrganizerEvents extends StatelessWidget {
  final VoidCallback onCreate;
  final void Function(EventModel event) onManage;

  const OrganizerEvents({
    super.key,
    required this.onCreate,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'My Events',
                  subtitle: 'Create and manage your staffing requirements.',
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  text: 'Create Event',
                  icon: Icons.add_rounded,
                  onPressed: onCreate,
                ),
                const SizedBox(height: 24),
                ...demoEvents.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: event,
                      organizerMode: true,
                      onTap: () => onManage(event),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrganizerApplicants extends StatelessWidget {
  const OrganizerApplicants({super.key});

  @override
  Widget build(BuildContext context) {
    final applicants = [
      ('Rahul Sharma', 'Event Coordinator', 'College Tech Fest', '4.8'),
      ('Ananya Singh', 'Technical Support', 'College Tech Fest', '4.7'),
      ('Aman Verma', 'Ground Coordinator', 'Sports Meet', '4.9'),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Applicants',
                  subtitle: 'Review and manage professional applications.',
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt_outlined),
                      SizedBox(width: 10),
                      Text('Filter by event / role'),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...applicants.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ApplicantCard(
                      name: a.$1,
                      role: a.$2,
                      event: a.$3,
                      rating: a.$4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplicantCard extends StatelessWidget {
  final String name;
  final String role;
  final String event;
  final String rating;

  const ApplicantCard({
    super.key,
    required this.name,
    required this.role,
    required this.event,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF5B4BFF).withOpacity(.1),
            child: const Icon(Icons.person_rounded,
                color: Color(0xFF5B4BFF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text('$role • $event',
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 5),
                Text('★ $rating',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => showInfo(context, '$name profile opened.'),
            child: const Text('View'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => showInfo(context, '$name accepted for $role.'),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}

class OrganizerProfile extends StatelessWidget {
  const OrganizerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                const PageHeader(
                  title: 'Organizer Profile',
                  subtitle: 'Manage your account information.',
                ),
                const SizedBox(height: 25),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF5B4BFF).withOpacity(.1),
                  child: const Icon(Icons.business_rounded,
                      size: 42, color: Color(0xFF5B4BFF)),
                ),
                const SizedBox(height: 20),
                const Text('EventFlex Organizer',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 25),
                profileTile(Icons.person_outline, 'Name', 'EventFlex Organizer'),
                profileTile(Icons.email_outlined, 'Email', 'organizer@test.com'),
                profileTile(Icons.phone_outlined, 'Phone', '9999999999'),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => confirmLogout(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrganizerEventManagement extends StatefulWidget {
  final EventModel event;

  const OrganizerEventManagement({super.key, required this.event});

  @override
  State<OrganizerEventManagement> createState() =>
      _OrganizerEventManagementState();
}

class _OrganizerEventManagementState extends State<OrganizerEventManagement> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Event')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventCard(
                    event: event,
                    organizerMode: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  SectionTitle(
                    title: 'Staffing Requirements',
                    action: 'Add Role',
                    onAction: () async {
                      final role = await Navigator.push<StaffingRole>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddRoleScreen(),
                        ),
                      );
                      if (role != null) {
                        setState(() => event.roles.add(role));
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ...event.roles.map(
                    (role) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RoleCard(
                        role: role,
                        onEdit: () => showInfo(context, 'Edit role flow ready for API integration.'),
                        onDelete: () {
                          setState(() => event.roles.remove(role));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'View Applications (${event.applicants})',
                    icon: Icons.people_rounded,
                    onPressed: () => showInfo(
                      context,
                      'Application management screen is ready for backend data.',
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
  int step = 0;
  String eventType = 'College Event';
  DateTime? date;
  TimeOfDay? time;

  final name = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();

  final List<StaffingRole> roles = [];

  final types = const [
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

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    location.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (d != null) setState(() => date = d);
  }

  Future<void> chooseTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (t != null) setState(() => time = t);
  }

  Future<void> addRole() async {
    final role = await Navigator.push<StaffingRole>(
      context,
      MaterialPageRoute(builder: (_) => const AddRoleScreen()),
    );
    if (role != null) setState(() => roles.add(role));
  }

  void createEvent() {
    if (name.text.trim().isEmpty ||
        location.text.trim().isEmpty ||
        date == null ||
        time == null ||
        roles.isEmpty) {
      showInfo(
        context,
        'Please complete event details and add at least one staffing role.',
      );
      return;
    }

    Navigator.pop(
      context,
      EventModel(
        name: name.text.trim(),
        type: eventType,
        description: description.text.trim(),
        date: date!,
        time: time!,
        location: location.text.trim(),
        roles: List.from(roles),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Step ${step + 1} of 3')),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (step + 1) / 3,
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF5B4BFF),
                  ),
                  const SizedBox(height: 26),
                  if (step == 0) buildStepOne(),
                  if (step == 1) buildStepTwo(),
                  if (step == 2) buildStepThree(),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (step > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => step--),
                            child: const Text('Back'),
                          ),
                        ),
                      if (step > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          text: step == 2 ? 'Publish Event' : 'Continue',
                          onPressed: () {
                            if (step < 2) {
                              setState(() => step++);
                            } else {
                              createEvent();
                            }
                          },
                        ),
                      ),
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

  Widget buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event Information',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text('Tell professionals what your event is about.',
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
        TextField(
          controller: name,
          decoration: const InputDecoration(
            labelText: 'Event Name',
            prefixIcon: Icon(Icons.event_outlined),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: eventType,
          decoration: const InputDecoration(
            labelText: 'Event Type',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: types
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) => setState(() => eventType = v!),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: description,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined),
          ),
        ),
      ],
    );
  }

  Widget buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date & Location',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text('Add when and where the event will happen.',
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
        _PickerTile(
          icon: Icons.calendar_month_rounded,
          title: 'Event Date',
          value: date == null ? 'Select date' : formatDate(date!),
          onTap: chooseDate,
        ),
        const SizedBox(height: 12),
        _PickerTile(
          icon: Icons.access_time_rounded,
          title: 'Event Time',
          value: time == null ? 'Select time' : time!.format(context),
          onTap: chooseTime,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: location,
          decoration: const InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }

  Widget buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Staffing Requirements',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text(
          'Add the exact custom roles your event needs.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          text: 'Add Custom Staffing Role',
          icon: Icons.add_rounded,
          onPressed: addRole,
        ),
        const SizedBox(height: 16),
        if (roles.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.groups_rounded,
                    size: 42, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                const Text('No roles added yet',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Create your first custom role above.',
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ...roles.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RoleCard(
              role: entry.value,
              onEdit: () {},
              onDelete: () => setState(() => roles.removeAt(entry.key)),
            ),
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5B4BFF)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({super.key});

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final name = TextEditingController();
  final description = TextEditingController();
  final people = TextEditingController(text: '1');
  final payment = TextEditingController();
  final skills = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    people.dispose();
    payment.dispose();
    skills.dispose();
    super.dispose();
  }

  void save() {
    if (name.text.trim().isEmpty) {
      showInfo(context, 'Enter a role name.');
      return;
    }

    Navigator.pop(
      context,
      StaffingRole(
        name: name.text.trim(),
        description: description.text.trim(),
        people: int.tryParse(people.text) ?? 1,
        payment: double.tryParse(payment.text) ?? 0,
        skills: skills.text.trim().isEmpty ? 'Not specified' : skills.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Role')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Staffing Role',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text('Define exactly what the event needs.',
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Role Name',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Role Description',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: people,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'People Required',
                            prefixIcon: Icon(Icons.people_outline),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: payment,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Payment / Person',
                            prefixIcon: Icon(Icons.currency_rupee),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: skills,
                    decoration: const InputDecoration(
                      labelText: 'Required Skills',
                      hintText: 'Communication, Management...',
                      prefixIcon: Icon(Icons.stars_outlined),
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Add Role',
                    icon: Icons.add_rounded,
                    onPressed: save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFESSIONAL SHELL
// ============================================================

class ProfessionalShell extends StatefulWidget {
  const ProfessionalShell({super.key});

  @override
  State<ProfessionalShell> createState() => _ProfessionalShellState();
}

class _ProfessionalShellState extends State<ProfessionalShell> {
  int index = 0;
  String selectedType = 'College Event';

  @override
  Widget build(BuildContext context) {
    final pages = [
      ProfessionalDashboard(
        eventType: selectedType,
        onTypeChanged: (type) => setState(() => selectedType = type),
        onEventTap: openEvent,
      ),
      BrowseEvents(
        eventType: selectedType,
        onTypeChanged: (type) => setState(() => selectedType = type),
        onEventTap: openEvent,
      ),
      const MyApplications(),
      ProfessionalProfile(eventType: selectedType),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void openEvent(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfessionalEventDetails(event: event),
      ),
    );
  }
}

class ProfessionalDashboard extends StatelessWidget {
  final String eventType;
  final ValueChanged<String> onTypeChanged;
  final void Function(EventModel event) onEventTap;

  const ProfessionalDashboard({
    super.key,
    required this.eventType,
    required this.onTypeChanged,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final events = demoEvents.where((e) => e.type == eventType).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Hello, Professional 👋',
                  subtitle: 'Discover opportunities that match your skills.',
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4BFF).withOpacity(.07),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_rounded,
                          color: Color(0xFF5B4BFF), size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Build your professional profile',
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            SizedBox(height: 4),
                            Text(
                              'Add skills, experience and certifications to improve your opportunities.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Choose Event Type'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: eventType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
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
                  ]
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => onTypeChanged(v!),
                ),
                const SizedBox(height: 26),
                const SectionTitle(title: 'Relevant Opportunities'),
                const SizedBox(height: 12),
                if (events.isEmpty)
                  emptyState(
                    'No matching events yet',
                    'Try another event type or check back later.',
                  ),
                ...events.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: event,
                      onTap: () => onEventTap(event),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrowseEvents extends StatelessWidget {
  final String eventType;
  final ValueChanged<String> onTypeChanged;
  final void Function(EventModel event) onEventTap;

  const BrowseEvents({
    super.key,
    required this.eventType,
    required this.onTypeChanged,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final events = demoEvents.where((e) => e.type == eventType).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Explore Events',
                  subtitle: 'Search and discover staffing opportunities.',
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: eventType,
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    prefixIcon: Icon(Icons.filter_alt_outlined),
                  ),
                  items: const [
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
                  ]
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => onTypeChanged(v!),
                ),
                const SizedBox(height: 22),
                ...events.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: event,
                      onTap: () => onEventTap(event),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfessionalEventDetails extends StatefulWidget {
  final EventModel event;

  const ProfessionalEventDetails({super.key, required this.event});

  @override
  State<ProfessionalEventDetails> createState() =>
      _ProfessionalEventDetailsState();
}

class _ProfessionalEventDetailsState extends State<ProfessionalEventDetails> {
  final Set<StaffingRole> selected = {};

  void apply() {
    if (selected.isEmpty) {
      showInfo(context, 'Select at least one role before applying.');
      return;
    }

    for (final role in selected) {
      final existing = demoApplications.any(
        (a) => a.event == widget.event && a.role == role,
      );
      if (!existing) {
        demoApplications.add(
          ApplicationModel(event: widget.event, role: role),
        );
      }
    }

    showInfo(
      context,
      'Application submitted for ${selected.length} selected role(s).',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: PrimaryButton(
            text: selected.isEmpty
                ? 'Select Roles to Apply'
                : 'Apply for ${selected.length} Role(s)',
            icon: Icons.send_rounded,
            onPressed: selected.isEmpty ? null : apply,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B4BFF).withOpacity(.09),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(event.type,
                        style: const TextStyle(
                            color: Color(0xFF5143D8),
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _Info(
                        icon: Icons.calendar_month_rounded,
                        text: formatDate(event.date),
                      ),
                      _Info(
                        icon: Icons.access_time_rounded,
                        text: event.time.format(context),
                      ),
                      _Info(
                        icon: Icons.location_on_outlined,
                        text: event.location,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const SectionTitle(title: 'About Event'),
                  const SizedBox(height: 8),
                  Text(event.description,
                      style: TextStyle(
                          color: Colors.grey.shade700, height: 1.5)),
                  const SizedBox(height: 26),
                  const SectionTitle(
                    title: 'Available Roles',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You can select multiple roles from this event.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ...event.roles.map(
                    (role) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RoleCard(
                        role: role,
                        selected: selected.contains(role),
                        onTap: () {
                          setState(() {
                            if (selected.contains(role)) {
                              selected.remove(role);
                            } else {
                              selected.add(role);
                            }
                          });
                        },
                      ),
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
}

class MyApplications extends StatelessWidget {
  const MyApplications({super.key});

  Color statusColor(String status) {
    if (status == 'Accepted') return Colors.green;
    if (status == 'Rejected') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'My Applications',
                  subtitle: 'Track every role you have applied for.',
                ),
                const SizedBox(height: 22),
                if (demoApplications.isEmpty)
                  emptyState(
                    'No applications yet',
                    'Explore events and apply for suitable roles.',
                  ),
                ...demoApplications.map(
                  (application) {
                    final color = statusColor(application.status);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: color.withOpacity(.1),
                              child: Icon(Icons.assignment_rounded,
                                  color: color),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(application.event.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(application.role.name),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${formatDate(application.event.date)} • ${application.event.location}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: color.withOpacity(.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                application.status,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfessionalProfile extends StatefulWidget {
  final String eventType;

  const ProfessionalProfile({super.key, required this.eventType});

  @override
  State<ProfessionalProfile> createState() => _ProfessionalProfileState();
}

class _ProfessionalProfileState extends State<ProfessionalProfile> {
  final skills = TextEditingController();
  final experience = TextEditingController();
  final certifications = TextEditingController();
  final location = TextEditingController();

  @override
  void dispose() {
    skills.dispose();
    experience.dispose();
    certifications.dispose();
    location.dispose();
    super.dispose();
  }

  List<String> dynamicFields() {
    switch (widget.eventType) {
      case 'Sports Event':
        return ['Sports Experience', 'Team Coordination'];
      case 'Technical Event':
        return ['Technical Skills', 'Projects / Portfolio'];
      case 'Wedding / Social Event':
        return ['Wedding / Social Experience', 'Guest Management'];
      case 'Corporate Event':
        return ['Corporate Experience', 'Professional Skills'];
      case 'Concert / Festival':
        return ['Stage / Festival Experience', 'Crowd Management'];
      default:
        return ['Relevant Experience'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Professional Profile',
                  subtitle: 'Build a trusted profile for event opportunities.',
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor:
                            const Color(0xFF5B4BFF).withOpacity(.1),
                        child: const Icon(Icons.person_rounded,
                            size: 44, color: Color(0xFF5B4BFF)),
                      ),
                      const SizedBox(height: 10),
                      const Text('Rahul Sharma',
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.verified_rounded,
                              size: 17, color: Colors.green),
                          SizedBox(width: 5),
                          Text('Demo verified profile',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text('Selected Event Type',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4BFF).withOpacity(.06),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(widget.eventType,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5143D8))),
                ),
                const SizedBox(height: 20),
                ...dynamicFields().map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: field,
                        prefixIcon: const Icon(Icons.work_outline_rounded),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: skills,
                  decoration: const InputDecoration(
                    labelText: 'Skills',
                    hintText: 'Communication, Management...',
                    prefixIcon: Icon(Icons.stars_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: experience,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.history_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: certifications,
                  decoration: const InputDecoration(
                    labelText: 'Certifications',
                    prefixIcon: Icon(Icons.workspace_premium_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  text: 'Save Profile',
                  icon: Icons.save_outlined,
                  onPressed: () => showInfo(context, 'Profile saved locally. Connect API to persist it.'),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => confirmLogout(context),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// AUTH HELPERS
// ============================================================

Future<void> confirmLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (shouldLogout == true && context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
}

// ============================================================
// HELPERS
// ============================================================

Widget profileTile(IconData icon, String title, String value) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF5B4BFF)),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    ),
  );
}

Widget emptyState(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      children: [
        Icon(Icons.inbox_outlined, size: 46, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        const SizedBox(height: 5),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600)),
      ],
    ),
  );
}

String formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

void showInfo(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
